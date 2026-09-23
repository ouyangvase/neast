<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Kit\Token;
use App\Model\AdminModel;
use Hyperf\Di\Annotation\Inject;

class AuthService
{
    #[Inject]
    protected PermissionService $permissionService;

    /**
     * Redis 空闲过期窗口（秒）：2 小时无请求则过期
     */
    public const IDLE_TTL = 7200;

    /**
     * JWT 自身过期时间（秒）：设很长，实际过期以 Redis TTL 为准
     */
    public const JWT_TTL = 315360000;

    /**
     * 登录
     */
    public function login(string $username, string $password): array
    {
        $admin = AdminModel::query()->with(['role:id,name,code,permissions'])
            ->where('username', $username)
            ->first();

        if (! $admin || ! password_verify($password, (string) $admin->password)) {
            throw new AppException('Account or password is incorrect');
        }

        if ((int) $admin->status !== 1) {
            throw new AppException('Account has been disabled, please contact the administrator');
        }

        $user = $this->formatUser($admin);

        $jwt = Token::createToken($user, $admin->id, 'admin', self::JWT_TTL);
        Token::set_admin_token($jwt, $admin->id, self::IDLE_TTL);

        return [
            'access_token' => $jwt,
            'token_type' => 'Bearer',
            'user' => $user,
        ];
    }

    /**
     * 当前用户信息
     */
    public function info(int $id): array
    {
        $admin = AdminModel::query()->with(['role:id,name,code,permissions'])->find($id);
        if (! $admin) {
            throw new AppException('User does not exist');
        }

        return $this->formatUser($admin);
    }

    /**
     * 登出
     */
    public function logout(int $id): void
    {
        Token::del_admin_token($id);
    }

    /**
     * 修改当前用户密码
     */
    public function changePassword(int $id, string $oldPassword, string $newPassword): void
    {
        $admin = AdminModel::query()->find($id);
        if (! $admin) {
            throw new AppException('User does not exist');
        }

        if (! password_verify($oldPassword, (string) $admin->password)) {
            throw new AppException('Old password is incorrect');
        }

        $newPassword = trim($newPassword);
        if (strlen($newPassword) < 6) {
            throw new AppException('New password length cannot be less than 6 digits');
        }

        if (password_verify($newPassword, (string) $admin->password)) {
            throw new AppException('New password cannot be the same as the old password');
        }

        $admin->password = password_hash($newPassword, PASSWORD_DEFAULT);
        $admin->save();

        $this->logout($id);
    }

    private function formatUser(AdminModel $admin): array
    {
        $roleCode = $admin->role?->code ?? '';
        $permissions = $this->permissionService->resolveUserPermissions($admin);

        return [
            'id' => (int) $admin->id,
            'username' => $admin->username,
            'real_name' => $admin->real_name,
            'email' => $admin->email,
            'phone' => $admin->phone,
            'avatar' => $admin->avatar,
            'role_id' => (int) $admin->role_id,
            'role_name' => $admin->role?->name ?? '',
            'role_code' => $roleCode,
            'permissions' => $permissions,
            'status' => (int) $admin->status,
        ];
    }
}
