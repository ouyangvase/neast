<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Middleware\AppAuthMiddleware;
use App\Middleware\AppOptionalAuthMiddleware;
use App\Service\MerchantService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端商家
 */
#[Controller(prefix: '/app/merchant')]
class Merchant extends AbstractController
{
    #[Inject]
    protected MerchantService $service;

    /**
     * 商家分类列表
     */
    #[Middleware(AppOptionalAuthMiddleware::class)]
    #[RequestMapping(path: 'categories', methods: ['GET'])]
    public function categories(): ResponseInterface
    {
        return $this->success($this->service->appCategories());
    }

    /**
     * 商家列表（按距离排序）
     */
    #[Middleware(AppOptionalAuthMiddleware::class)]
    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'page' => 'nullable|integer|min:1',
            'limit' => 'nullable|integer|min:1',
            'category_id' => 'nullable|integer|min:1',
        ], [
            'latitude.required' => 'Latitude is required',
            'latitude.numeric' => 'Invalid latitude',
            'longitude.required' => 'Longitude is required',
            'longitude.numeric' => 'Invalid longitude',
            'page.integer' => 'Invalid page',
            'page.min' => 'Invalid page',
            'limit.integer' => 'Invalid limit',
            'limit.min' => 'Invalid limit',
            'category_id.integer' => 'Invalid category id',
            'category_id.min' => 'Invalid category id',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $page = max(1, (int) ($params['page'] ?? 1));
        $limit = (int) ($params['limit'] ?? 10);
        $limit = $limit > 0 ? $limit : 10;

        return $this->success($this->service->appList(
            (float) $params['latitude'],
            (float) $params['longitude'],
            $page,
            $limit,
            $this->parseCategoryId($params)
        ));
    }

    /**
     * 推荐商家列表（按距离排序）
     */
    #[Middleware(AppOptionalAuthMiddleware::class)]
    #[RequestMapping(path: 'recommended', methods: ['GET'])]
    public function recommended(RequestInterface $request): ResponseInterface
    {
        return $this->paginatedLocationList(
            $request,
            fn (float $lat, float $lng, int $page, int $limit, ?int $_) => $this->service->appRecommended(
                $lat,
                $lng,
                $page,
                $limit
            )
        );
    }

    /**
     * 附近商家列表（有坐标、按距离排序、分页）
     */
    #[Middleware(AppOptionalAuthMiddleware::class)]
    #[RequestMapping(path: 'nearby/list', methods: ['GET'])]
    public function nearbyList(RequestInterface $request): ResponseInterface
    {
        return $this->paginatedLocationList(
            $request,
            fn (float $lat, float $lng, int $page, int $limit, ?int $categoryId) => $this->service->appNearbyList(
                $lat,
                $lng,
                $page,
                $limit,
                $categoryId
            ),
            withCategoryFilter: true
        );
    }

    /**
     * 附近商家（半径写死 20km，用于分布展示）
     */
    #[Middleware(AppOptionalAuthMiddleware::class)]
    #[RequestMapping(path: 'nearby', methods: ['GET'])]
    public function nearby(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'category_id' => 'nullable|integer|min:1',
        ], [
            'latitude.required' => 'Latitude is required',
            'latitude.numeric' => 'Invalid latitude',
            'longitude.required' => 'Longitude is required',
            'longitude.numeric' => 'Invalid longitude',
            'category_id.integer' => 'Invalid category id',
            'category_id.min' => 'Invalid category id',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->appNearby(
            (float) $params['latitude'],
            (float) $params['longitude'],
            $this->parseCategoryId($params)
        ));
    }

    /**
     * 商家详情
     */
    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'detail', methods: ['GET'])]
    public function detail(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();

        $validator = di(ValidatorFactory::class)->make($params, [
            'id' => 'required|integer|min:1',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
        ], [
            'id.required' => 'Merchant id is required',
            'id.integer' => 'Invalid merchant id',
            'id.min' => 'Invalid merchant id',
            'latitude.numeric' => 'Invalid latitude',
            'longitude.numeric' => 'Invalid longitude',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $latitude = isset($params['latitude']) && $params['latitude'] !== ''
            ? (float) $params['latitude']
            : null;
        $longitude = isset($params['longitude']) && $params['longitude'] !== ''
            ? (float) $params['longitude']
            : null;

        return $this->success($this->service->appDetail(
            (int) $params['id'],
            $latitude,
            $longitude
        ));
    }

    /**
     * @param callable(float, float, int, int, ?int): array $handler
     */
    private function paginatedLocationList(
        RequestInterface $request,
        callable $handler,
        bool $withCategoryFilter = false
    ): ResponseInterface {
        $params = $request->all();

        $rules = [
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'page' => 'nullable|integer|min:1',
            'limit' => 'nullable|integer|min:1',
        ];
        $messages = [
            'latitude.required' => 'Latitude is required',
            'latitude.numeric' => 'Invalid latitude',
            'longitude.required' => 'Longitude is required',
            'longitude.numeric' => 'Invalid longitude',
            'page.integer' => 'Invalid page',
            'page.min' => 'Invalid page',
            'limit.integer' => 'Invalid limit',
            'limit.min' => 'Invalid limit',
        ];

        if ($withCategoryFilter) {
            $rules['category_id'] = 'nullable|integer|min:1';
            $messages['category_id.integer'] = 'Invalid category id';
            $messages['category_id.min'] = 'Invalid category id';
        }

        $validator = di(ValidatorFactory::class)->make($params, $rules, $messages);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $page = max(1, (int) ($params['page'] ?? 1));
        $limit = (int) ($params['limit'] ?? 10);
        $limit = $limit > 0 ? $limit : 10;
        $categoryId = $withCategoryFilter ? $this->parseCategoryId($params) : null;

        return $this->success($handler(
            (float) $params['latitude'],
            (float) $params['longitude'],
            $page,
            $limit,
            $categoryId
        ));
    }

    private function parseCategoryId(array $params): ?int
    {
        if (! isset($params['category_id']) || $params['category_id'] === '') {
            return null;
        }

        $categoryId = (int) $params['category_id'];

        return $categoryId > 0 ? $categoryId : null;
    }
}
