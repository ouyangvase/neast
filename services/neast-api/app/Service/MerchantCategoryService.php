<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\MerchantCategoryModel;
use Hyperf\HttpServer\Contract\RequestInterface;

class MerchantCategoryService
{
    /**
     * 分类列表（关键词搜索、分页）
     */
    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $keyword = trim((string) $request->input('keyword', ''));

        $query = MerchantCategoryModel::query();

        if ($keyword !== '') {
            $query->where('name', 'like', "%{$keyword}%");
        }

        $total = (clone $query)->count();

        $items = $query->orderBy('id', 'desc')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (MerchantCategoryModel $category) => $category->toArray())
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * 创建分类
     */
    public function create(array $params): array
    {
        $name = trim((string) ($params['name'] ?? ''));
        $this->assertNameUnique($name);

        $category = new MerchantCategoryModel();
        $category->name = $name;
        $category->save();

        return $category->toArray();
    }

    /**
     * 更新分类
     */
    public function update(int $id, array $params): array
    {
        $category = $this->findOrFail($id);
        $name = trim((string) ($params['name'] ?? ''));

        if ($name !== $category->name) {
            $this->assertNameUnique($name, $id);
        }

        $category->name = $name;
        $category->save();

        return $category->toArray();
    }

    /**
     * 删除分类（软删除）
     */
    public function delete(int $id): void
    {
        $category = $this->findOrFail($id);
        $category->delete();
    }

    /**
     * 分类下拉
     */
    public function options(): array
    {
        return MerchantCategoryModel::query()
            ->orderBy('id', 'asc')
            ->get(['id', 'name'])
            ->toArray();
    }

    private function assertNameUnique(string $name, ?int $excludeId = null): void
    {
        if ($name === '') {
            throw new AppException('Category name is required');
        }

        $query = MerchantCategoryModel::withTrashed()->where('name', $name);
        if ($excludeId !== null) {
            $query->where('id', '<>', $excludeId);
        }

        if ($query->exists()) {
            throw new AppException('Category name already exists');
        }
    }

    private function findOrFail(int $id): MerchantCategoryModel
    {
        $category = MerchantCategoryModel::query()->find($id);
        if (! $category) {
            throw new AppException('Category not found');
        }

        return $category;
    }
}
