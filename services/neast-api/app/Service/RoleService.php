<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\AdminModel;
use App\Model\AdminRoleModel;
use App\Model\PermissionModel;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Contract\RequestInterface;

class RoleService
{
    #[Inject]
    protected PermissionService $permissionService;

    /**
     * 角色列表（关键词搜索、分页）
     */
    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $keyword = trim((string) $request->input('keyword', ''));

        $query = AdminRoleModel::query();

        if ($keyword !== '') {
            $query->where('name', 'like', "%{$keyword}%");
        }

        $total = (clone $query)->count();

        $items = $query->orderBy('id', 'asc')
            ->forPage($page, $limit)
            ->get()
            ->toArray();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * 角色详情（含权限码，供编辑回显）
     */
    public function detail(int $id): array
    {
        $role = $this->findOrFail($id);
        $data = $role->toArray();
        $data['permissions'] = $this->permissionService->resolveRolePermissions($role);
        return $data;
    }

    /**
     * 创建角色
     */
    public function create(array $params): AdminRoleModel
    {
        $name = trim((string) ($params['name'] ?? ''));
        $code = trim((string) ($params['code'] ?? ''));

        if ($name === '') {
            throw new AppException('请输入角色名称');
        }
        if ($code !== '' && AdminRoleModel::query()->where('code', $code)->exists()) {
            throw new AppException('角色编码已存在');
        }
        if (strtoupper($code) === 'ADMIN') {
            throw new AppException('不可创建超级管理员角色');
        }

        $role = new AdminRoleModel();
        $role->name = $name;
        $role->code = $code !== '' ? $code : 'ROLE_' . strtoupper(substr(md5((string) microtime(true)), 0, 6));
        $role->description = (string) ($params['description'] ?? '');
        $role->permissions = $this->normalizePermissions($params['permissions'] ?? []);
        $role->status = (int) ($params['status'] ?? 1);
        $role->save();

        return $role;
    }

    /**
     * 更新角色
     */
    public function update(int $id, array $params): AdminRoleModel
    {
        $role = $this->findOrFail($id);
        $this->assertEditableRole($role);

        if (isset($params['name'])) {
            $role->name = trim((string) $params['name']);
        }
        if (isset($params['description'])) {
            $role->description = (string) $params['description'];
        }
        if (array_key_exists('permissions', $params)) {
            $role->permissions = $this->normalizePermissions($params['permissions']);
        }
        if (isset($params['status'])) {
            $role->status = (int) $params['status'];
        }
        $role->save();

        return $role;
    }

    /**
     * 删除角色（软删除）
     */
    public function delete(int $id): void
    {
        $role = $this->findOrFail($id);

        if ($role->code === 'ADMIN') {
            throw new AppException('超级管理员角色不可删除');
        }
        if (AdminModel::query()->where('role_id', $id)->exists()) {
            throw new AppException('该角色下仍有员工，无法删除');
        }

        $role->delete();
    }

    /**
     * 角色下拉（启用角色）
     */
    public function options(): array
    {
        return AdminRoleModel::query()
            ->where('status', 1)
            ->orderBy('id', 'asc')
            ->get(['id', 'name', 'code'])
            ->toArray();
    }

    /**
     * 权限树（由 t_permission 按 parent_id 组装）
     */
    public function permissionTree(): array
    {
        $all = PermissionModel::query()
            ->where('status', 1)
            ->orderBy('sort', 'asc')
            ->orderBy('id', 'asc')
            ->get(['id', 'code', 'name', 'parent_id', 'type', 'path'])
            ->toArray();

        return $this->buildTree($all, 0);
    }

    private function buildTree(array $items, int $parentId): array
    {
        $tree = [];
        foreach ($items as $item) {
            if ((int) $item['parent_id'] === $parentId) {
                $children = $this->buildTree($items, (int) $item['id']);
                if ($children) {
                    $item['children'] = $children;
                }
                $tree[] = $item;
            }
        }
        return $tree;
    }

    private function normalizePermissions(mixed $permissions): array
    {
        if (! is_array($permissions)) {
            return [];
        }
        return array_values(array_unique(array_filter(array_map(
            fn ($p) => (string) $p,
            $permissions
        ), fn ($p) => $p !== '')));
    }

    private function assertEditableRole(AdminRoleModel $role): void
    {
        if ($role->code === 'ADMIN') {
            throw new AppException('超级管理员角色不可编辑');
        }
    }

    private function findOrFail(int $id): AdminRoleModel
    {
        $role = AdminRoleModel::query()->find($id);
        if (! $role) {
            throw new AppException('角色不存在');
        }
        return $role;
    }
}
