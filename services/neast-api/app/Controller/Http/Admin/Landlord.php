<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\LandlordPropertyService;
use App\Service\LandlordService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东管理
 */
#[Controller(prefix: '/admin/landlord')]
#[Middleware(AdminAuthMiddleware::class)]
class Landlord extends AbstractController
{
    #[Inject]
    protected LandlordService $service;

    #[Inject]
    protected LandlordPropertyService $propertyService;

    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        return $this->success($this->service->list($request));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['GET'])]
    public function detail(int $id): ResponseInterface
    {
        return $this->success($this->service->detail($id));
    }

    #[RequestMapping(path: 'create', methods: ['POST'])]
    public function create(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'first_name' => 'required|string|max:64',
            'last_name' => 'required|string|max:64',
            'phone' => 'required|string|max:32',
            'email' => 'nullable|email|max:128',
        ], $this->landlordCreateMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->create($params));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['PUT'])]
    public function update(int $id, RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'first_name' => 'required|string|max:64',
            'last_name' => 'required|string|max:64',
            'phone' => 'required|string|max:32',
            'email' => 'nullable|email|max:128',
        ], $this->landlordUpdateMessages());

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->update($id, $params));
    }

    private function landlordCommonMessages(): array
    {
        return [
            'first_name.required' => 'Please enter the landlord first name',
            'first_name.max' => 'The first name must be less than 64 characters',
            'last_name.required' => 'Please enter the landlord last name',
            'last_name.max' => 'The last name must be less than 64 characters',
            'phone.required' => 'Please enter the landlord phone number',
            'phone.max' => 'The landlord phone number must be less than 32 characters',
            'email.email' => 'Email address is invalid',
            'email.max' => 'The landlord email address must be less than 128 characters',
        ];
    }

    private function landlordCreateMessages(): array
    {
        return $this->landlordCommonMessages();
    }

    private function landlordUpdateMessages(): array
    {
        return $this->landlordCommonMessages();
    }

    #[RequestMapping(path: 'id/{id}/status', methods: ['PUT'])]
    public function status(int $id, RequestInterface $request): ResponseInterface
    {
        $status = (int) $request->input('status', 1);
        $this->service->toggleStatus($id, $status);

        return $this->success();
    }

    #[RequestMapping(path: 'id/{id}/properties', methods: ['GET'])]
    public function properties(int $id, RequestInterface $request): ResponseInterface
    {
        return $this->success($this->propertyService->listByLandlord($id, $request));
    }
}
