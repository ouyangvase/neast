<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Middleware\AppAuthMiddleware;
use App\Model\UserModel;
use App\Service\AppUserService;
use App\Service\TentScoreService;
use Carbon\Carbon;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端用户
 */
#[Controller(prefix: '/app/user')]
class User extends AbstractController
{
    #[Inject]
    protected AppUserService $service;

    #[Inject]
    protected TentScoreService $tentScoreService;

    /**
     * 获取个人资料
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'profile', methods: ['GET'])]
    public function getProfile(): ResponseInterface
    {
        $auth = Context::get('app_auth');

        return $this->success($this->service->profile((int) $auth->id));
    }

    /**
     * 获取 Tent Score（租客信用评分）
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'tent-score', methods: ['GET'])]
    public function tentScore(): ResponseInterface
    {
        $auth = Context::get('app_auth');

        return $this->success($this->tentScoreService->info((int) $auth->id));
    }

    /**
     * 完善 / 更新个人资料
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'profile', methods: ['POST'])]
    public function updateProfile(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $user = UserModel::query()->find((int) $auth->id);
        if (! $user) {
            return $this->error('User does not exist');
        }

        $params = $request->all();
        if (! empty($params['id_valid_until'])) {
            try {
                $params['id_valid_until'] = Carbon::parse((string) $params['id_valid_until'])->format('Y-m-d');
            } catch (\Throwable) {
                return $this->error('Invalid valid until date');
            }
        }

        $isFirstCompletion = trim((string) $user->id_number) === '';
        $idType = $isFirstCompletion
            ? trim((string) ($params['id_type'] ?? ''))
            : (string) $user->id_type;

        $rules = [
            'first_name' => 'required|string|max:64',
            'last_name' => 'required|string|max:64',
            'address' => 'nullable|string|max:255',
            'invitation_code' => 'nullable|string|max:64',
            'email' => 'nullable|email|max:128',
        ];

        if ($isFirstCompletion) {
            $rules['id_type'] = 'required|in:id_card,passport';
            $rules['id_number'] = 'required|string|max:64';
        }

        if ($idType === UserModel::ID_TYPE_PASSPORT) {
            $rules['id_valid_until'] = 'required|date_format:Y-m-d';
        } else {
            $rules['id_valid_until'] = 'nullable|date_format:Y-m-d';
        }

        $validator = di(ValidatorFactory::class)->make($params, $rules, $this->profileMessages($isFirstCompletion));

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $this->service->completeProfile((int) $auth->id, $params);

        return $this->success();
    }

    /**
     * 发送删号验证码（H5 公开接口）
     */
    #[RequestMapping(path: 'delete-account/send-code', methods: ['POST'])]
    public function sendDeleteAccountCode(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'account' => 'required|string|max:128',
        ], [
            'account.required' => 'Phone number is required',
            'account.max' => 'Phone number is too long',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $this->service->sendDeleteAccountCode((string) $params['account']);

        return $this->success();
    }

    /**
     * 删除账号（H5 公开接口：手机号 + 验证码）
     */
    #[RequestMapping(path: 'delete-account/confirm', methods: ['POST'])]
    public function confirmDeleteAccount(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'account' => 'required|string|max:128',
            'code' => 'required|string|size:6',
        ], [
            'account.required' => 'Phone number is required',
            'account.max' => 'Phone number is too long',
            'code.required' => 'Verification code is required',
            'code.size' => 'Verification code must be 6 digits',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $this->service->deleteAccountByPhone(
            (string) $params['account'],
            (string) $params['code'],
        );

        return $this->success();
    }

    /**
     * 删除账号（App 登录态）
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'delete-account', methods: ['POST'])]
    public function deleteAccount(): ResponseInterface
    {
        $auth = Context::get('app_auth');
        $this->service->deleteAccount((int) $auth->id);

        return $this->success();
    }

    private function profileMessages(bool $isFirstCompletion): array
    {
        $messages = [
            'first_name.required' => 'Please enter your first name',
            'first_name.max' => 'The first name must be less than 64 characters',
            'last_name.required' => 'Please enter your last name',
            'last_name.max' => 'The last name must be less than 64 characters',
            'id_valid_until.required' => 'Please select the valid until date',
            'id_valid_until.date_format' => 'Invalid valid until date',
            'address.max' => 'The address must be less than 255 characters',
            'invitation_code.max' => 'The invitation code must be less than 64 characters',
            'email.email' => 'Email address is invalid',
            'email.max' => 'The email must be less than 128 characters',
        ];

        if ($isFirstCompletion) {
            $messages['id_type.required'] = 'Please select ID document type';
            $messages['id_type.in'] = 'Invalid ID document type';
            $messages['id_number.required'] = 'Please enter your ID number';
            $messages['id_number.max'] = 'The ID number must be less than 64 characters';
        }

        return $messages;
    }
}
