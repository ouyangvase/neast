<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\WebsiteImageModel;
use Hyperf\HttpServer\Contract\RequestInterface;

class WebsiteImageService
{
    /**
     * 官网图片列表（公开）
     *
     * @return array<int, array<string, mixed>>
     */
    public function publicList(): array
    {
        return WebsiteImageModel::query()
            ->orderByDesc('id')
            ->get(['id', 'image'])
            ->map(fn (WebsiteImageModel $item) => $this->formatPublicItem($item))
            ->all();
    }

    /**
     * 后台图片列表
     */
    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $query = WebsiteImageModel::query();
        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (WebsiteImageModel $item) => $this->formatAdminItem($item))
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * 创建图片
     *
     * @param array<string, mixed> $params
     * @return array<string, mixed>
     */
    public function create(array $params): array
    {
        $item = new WebsiteImageModel();
        $this->fillImage($item, $params);
        $item->save();

        return $this->formatAdminItem($item);
    }

    /**
     * 更新图片
     *
     * @param array<string, mixed> $params
     * @return array<string, mixed>
     */
    public function update(int $id, array $params): array
    {
        $item = $this->findOrFail($id);
        $this->fillImage($item, $params);
        $item->save();

        return $this->formatAdminItem($item);
    }

    /**
     * 删除图片
     */
    public function delete(int $id): void
    {
        $item = $this->findOrFail($id);
        $item->delete();
    }

    /**
     * @param array<string, mixed> $params
     */
    private function fillImage(WebsiteImageModel $item, array $params): void
    {
        $image = trim((string) ($params['image'] ?? ''));
        if ($image === '') {
            throw new AppException('Image is required');
        }

        $item->image = $image;
    }

    /**
     * @return array<string, mixed>
     */
    private function formatPublicItem(WebsiteImageModel $item): array
    {
        $image = (string) ($item->image ?? '');

        return [
            'id' => (int) $item->id,
            'image_url' => file_url($image),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function formatAdminItem(WebsiteImageModel $item): array
    {
        $data = $item->toArray();
        $image = (string) ($item->image ?? '');
        $data['image_url'] = file_url($image);

        return $data;
    }

    private function findOrFail(int $id): WebsiteImageModel
    {
        $item = WebsiteImageModel::query()->find($id);
        if (! $item) {
            throw new AppException('Website image not found');
        }

        return $item;
    }
}
