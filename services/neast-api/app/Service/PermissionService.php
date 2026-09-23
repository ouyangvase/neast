<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\AdminModel;
use App\Model\AdminRoleModel;
use App\Model\PermissionModel;

class PermissionService
{
    /**
     * 权限表全部启用中的 code
     */
    public function allCodes(): array
    {
        return PermissionModel::query()
            ->where('status', 1)
            ->orderBy('sort', 'asc')
            ->orderBy('id', 'asc')
            ->pluck('code')
            ->all();
    }

    /**
     * 解析用户拥有的权限码（ADMIN 查权限表全量）
     */
    public function resolveUserPermissions(AdminModel $admin): array
    {
        if (($admin->role?->code ?? '') === 'ADMIN') {
            return $this->allCodes();
        }

        return array_values(array_unique(array_filter(array_map(
            fn ($p) => (string) $p,
            (array) ($admin->role?->permissions ?? [])
        ), fn ($p) => $p !== '')));
    }

    /**
     * 解析角色拥有的权限码（ADMIN 查权限表全量）
     */
    public function resolveRolePermissions(AdminRoleModel $role): array
    {
        if ($role->code === 'ADMIN') {
            return $this->allCodes();
        }

        return array_values((array) ($role->permissions ?? []));
    }
}
