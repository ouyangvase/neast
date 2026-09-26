<?php

declare(strict_types=1);

namespace App\Controller\Http\Landlord;

use App\Controller\AbstractController;
use App\Middleware\LandlordAuthMiddleware;
use App\Service\LandlordPropertyService;
use Hyperf\Context\Context;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * 房东端物业
 */
#[Controller(prefix: '/landlord/property')]
class Property extends AbstractController
{
    #[Inject]
    protected LandlordPropertyService $service;

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        $auth = Context::get('landlord_auth');

        return $this->success($this->service->listForLandlord((int) $auth->id, $request));
    }

    #[Middleware(LandlordAuthMiddleware::class)]
    #[RequestMapping(path: 'create', methods: ['POST'])]
    public function create(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'name' => 'required|string|max:128',
            'address' => 'required|string|max:255',
            'image' => 'required|string|max:512',
        ], [
            'name.required' => 'Property name is required',
            'name.max' => 'Property name must be less than 128 characters',
            'address.required' => 'Address is required',
            'address.max' => 'Address must be less than 255 characters',
            'image.required' => 'Photo is required',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $auth = Context::get('landlord_auth');

        return $this->success($this->service->create((int) $auth->id, $params));
    }
}
