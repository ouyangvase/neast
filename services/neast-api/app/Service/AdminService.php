<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\AdminModel;
use App\Model\AdminRoleModel;
use Hyperf\HttpServer\Contract\RequestInterface;

class AdminService
{
    /**
     * 初始密码
     */
    public const DEFAULT_PASSWORD = '123456';

    /**
     * 员工列表（联表角色名、关键词/状态搜索、分页）
     */
    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $keyword = trim((string) $request->input('keyword', ''));
        $status = $request->input('status', null);

        $query = AdminModel::query()->with(['role:id,name']);

        if ($keyword !== '') {
            $query->where(function ($q) use ($keyword) {
                $q->where('username', 'like', "%{$keyword}%")
                    ->orWhere('real_name', 'like', "%{$keyword}%");
            });
        }

        if ($status !== null && $status !== '') {
            $query->where('status', (int) $status);
        }

        $total = (clone $query)->count();

        $items = $query->orderBy('id', 'desc')
            ->forPage($page, $limit)
            ->get()
            ->map(function (AdminModel $admin) {
                $data = $admin->toArray();
                $data['role_name'] = $admin->role?->name ?? '';
                unset($data['role']);
                return $data;
            })
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * 创建员工
     */
    public function create(array $params): AdminModel
    {
        $username = trim((string) ($params['username'] ?? ''));

        if (AdminModel::query()->where('username', $username)->exists()) {
            throw new AppException('登录账号已存在');
        }

        $password = (string) ($params['password'] ?? '');
        if ($password === '') {
            $password = self::DEFAULT_PASSWORD;
        }

        $admin = new AdminModel();
        $admin->username = $username;
        $admin->real_name = (string) ($params['real_name'] ?? '');
        $admin->email = (string) ($params['email'] ?? '');
        $admin->phone = (string) ($params['phone'] ?? '');
        $admin->role_id = (int) ($params['role_id'] ?? 0);
        $admin->data_scope = (string) ($params['data_scope'] ?? 'personal');
        $admin->status = (int) ($params['status'] ?? 1);
        $admin->password = password_hash($password, PASSWORD_DEFAULT);
        $admin->save();

        return $admin;
    }

    /**
     * 更新员工（账号不可改）
     */
    public function update(int $id, array $params): AdminModel
    {
        $admin = $this->findOrFail($id);

        $admin->real_name = (string) ($params['real_name'] ?? $admin->real_name);
        $admin->email = (string) ($params['email'] ?? $admin->email);
        $admin->phone = (string) ($params['phone'] ?? $admin->phone);
        if (isset($params['role_id'])) {
            $admin->role_id = (int) $params['role_id'];
        }
        if (isset($params['data_scope'])) {
            $admin->data_scope = (string) $params['data_scope'];
        }
        if (isset($params['status'])) {
            $admin->status = (int) $params['status'];
        }
        $admin->save();

        return $admin;
    }

    /**
     * 删除员工（软删除）
     */
    public function delete(int $id): void
    {
        $admin = $this->findOrFail($id);
        $admin->delete();
    }

    /**
     * 状态切换
     */
    public function toggleStatus(int $id, int $status): void
    {
        $admin = $this->findOrFail($id);
        $admin->status = $status === 1 ? 1 : 0;
        $admin->save();
    }

    /**
     * 重置密码为初始密码
     */
    public function resetPassword(int $id): void
    {
        $admin = $this->findOrFail($id);
        $admin->password = password_hash(self::DEFAULT_PASSWORD, PASSWORD_DEFAULT);
        $admin->save();
    }

    /**
     * 角色下拉（启用角色）
     */
    public function roleAll(): array
    {
        return AdminRoleModel::query()
            ->where('status', 1)
            ->orderBy('id', 'asc')
            ->get(['id', 'name', 'code', 'description', 'status'])
            ->toArray();
    }

    private function findOrFail(int $id): AdminModel
    {
        $admin = AdminModel::query()->find($id);
        if (! $admin) {
            throw new AppException('员工不存在');
        }
        return $admin;
    }
}
