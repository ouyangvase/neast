<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\UserChangeLogModel;
use App\Model\UserModel;
use Hyperf\HttpServer\Contract\RequestInterface;

class UserChangeLogService
{
    /**
     * 用户证件修改记录列表
     */
    public function listByUser(int $userId, RequestInterface $request): array
    {
        $this->assertUserExists($userId);

        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $query = UserChangeLogModel::query()
            ->with(['admin:id,real_name'])
            ->where('user_id', $userId);

        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(function (UserChangeLogModel $log) {
                $data = $log->toArray();
                unset($data['admin']);
                $data['operator_name'] = $log->admin?->real_name ?? '';

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
     * @param array<string, mixed> $before
     * @param array<string, mixed> $after
     */
    public function record(int $userId, array $before, array $after, int $adminId): void
    {
        $log = new UserChangeLogModel();
        $log->user_id = $userId;
        $log->before_data = $before;
        $log->after_data = $after;
        $log->admin_id = $adminId;
        $log->save();
    }

    private function assertUserExists(int $userId): void
    {
        if (! UserModel::query()->where('id', $userId)->exists()) {
            throw new AppException('User not found');
        }
    }
}
