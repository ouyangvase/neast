<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\UserChangeLogService;
use App\Service\UserService;
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
 * 用户管理
 */
#[Controller(prefix: '/admin/user')]
#[Middleware(AdminAuthMiddleware::class)]
class User extends AbstractController
{
    #[Inject]
    protected UserService $service;

    #[Inject]
    protected UserChangeLogService $changeLogService;

    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        return $this->success($this->service->list($request));
    }

    #[RequestMapping(path: 'id/{id}/status', methods: ['PUT'])]
    public function status(int $id, RequestInterface $request): ResponseInterface
    {
        $status = (int) $request->input('status', 1);
        $this->service->toggleStatus($id, $status);

        return $this->success();
    }

    #[RequestMapping(path: 'id/{id}/id-document', methods: ['PUT'])]
    public function updateIdDocument(int $id, RequestInterface $request): ResponseInterface
    {
        $params = $request->all();
        if (! empty($params['id_valid_until'])) {
            try {
                $params['id_valid_until'] = Carbon::parse((string) $params['id_valid_until'])->format('Y-m-d');
            } catch (\Throwable) {
                return $this->error('Invalid valid until date');
            }
        }

        $validator = di(ValidatorFactory::class)->make($params, [
            'id_type' => 'required|in:id_card,passport',
            'id_number' => 'required|string|max:64',
            'id_valid_until' => 'nullable|date_format:Y-m-d',
        ], [
            'id_type.required' => 'Please select ID document type',
            'id_type.in' => 'Invalid ID document type',
            'id_number.required' => 'Please enter ID number',
            'id_number.max' => 'The ID number must be less than 64 characters',
            'id_valid_until.date_format' => 'Invalid valid until date',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $adminId = (int) (Context::get('auth')?->id ?? 0);
        $this->service->updateIdDocument($id, $params, $adminId);

        return $this->success();
    }

    #[RequestMapping(path: 'id/{id}/change-logs', methods: ['GET'])]
    public function changeLogs(int $id, RequestInterface $request): ResponseInterface
    {
        return $this->success($this->changeLogService->listByUser($id, $request));
    }
}
