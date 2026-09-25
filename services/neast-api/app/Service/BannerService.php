<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\BannerModel;
use Hyperf\HttpServer\Contract\RequestInterface;

class BannerService
{
    /**
     * App 端首页 Banner 列表
     *
     * @return array<int, array<string, mixed>>
     */
    public function appList(): array
    {
        $now = date('Y-m-d H:i:s');

        return BannerModel::query()
            ->where('status', BannerModel::STATUS_ENABLED)
            ->where(function ($query) use ($now) {
                $query->whereNull('starts_at')->orWhere('starts_at', '<=', $now);
            })
            ->where(function ($query) use ($now) {
                $query->whereNull('ends_at')->orWhere('ends_at', '>=', $now);
            })
            ->orderByDesc('sort')
            ->orderByDesc('id')
            ->get(['id', 'image', 'link'])
            ->map(fn (BannerModel $banner) => $this->formatAppItem($banner))
            ->all();
    }

    /**
     * 后台 Banner 列表
     */
    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $status = $request->input('status', null);

        $query = BannerModel::query();

        if ($status !== null && $status !== '') {
            $query->where('status', (int) $status);
        }

        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('sort')
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (BannerModel $banner) => $this->formatAdminItem($banner))
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * 创建 Banner
     *
     * @param array<string, mixed> $params
     * @return array<string, mixed>
     */
    public function create(array $params): array
    {
        $banner = new BannerModel();
        $this->fillBanner($banner, $params);
        $banner->save();

        return $this->formatAdminItem($banner);
    }

    /**
     * 更新 Banner
     *
     * @param array<string, mixed> $params
     * @return array<string, mixed>
     */
    public function update(int $id, array $params): array
    {
        $banner = $this->findOrFail($id);
        $this->fillBanner($banner, $params);
        $banner->save();

        return $this->formatAdminItem($banner);
    }

    /**
     * 删除 Banner
     */
    public function delete(int $id): void
    {
        $banner = $this->findOrFail($id);
        $banner->delete();
    }

    /**
     * @param array<string, mixed> $params
     */
    private function fillBanner(BannerModel $banner, array $params): void
    {
        $image = trim((string) ($params['image'] ?? ''));
        if ($image === '') {
            throw new AppException('Banner image is required');
        }

        $banner->image = $image;
        $banner->link = trim((string) ($params['link'] ?? ''));
        $banner->sort = (int) ($params['sort'] ?? 0);
        $banner->starts_at = $params['starts_at'] ?? null;
        $banner->ends_at = $params['ends_at'] ?? null;
        $banner->status = (int) ($params['status'] ?? BannerModel::STATUS_ENABLED) === BannerModel::STATUS_DISABLED
            ? BannerModel::STATUS_DISABLED
            : BannerModel::STATUS_ENABLED;
    }

    /**
     * @return array<string, mixed>
     */
    private function formatAppItem(BannerModel $banner): array
    {
        $image = (string) ($banner->image ?? '');

        return [
            'id' => (int) $banner->id,
            'image' => $image,
            'image_url' => file_url($image),
            'link' => (string) ($banner->link ?? ''),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function formatAdminItem(BannerModel $banner): array
    {
        $data = $banner->toArray();
        $image = (string) ($banner->image ?? '');
        $data['image_url'] = file_url($image);

        return $data;
    }

    private function findOrFail(int $id): BannerModel
    {
        $banner = BannerModel::query()->find($id);
        if (! $banner) {
            throw new AppException('Banner not found');
        }

        return $banner;
    }
}
