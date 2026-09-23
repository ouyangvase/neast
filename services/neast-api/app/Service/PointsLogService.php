<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\PointsLogModel;
use App\Model\UserModel;
use Carbon\Carbon;

class PointsLogService
{
    /**
     * 写入一条积分收支流水（需在业务事务内调用）
     */
    public function log(int $userId, int $points, string $title, string $subtitle = ''): PointsLogModel
    {
        if ($userId <= 0) {
            throw new AppException('Invalid user');
        }

        if ($points === 0) {
            throw new AppException('Invalid points');
        }

        $record = new PointsLogModel();
        $record->user_id = $userId;
        $record->points = $points;
        $record->title = trim($title);
        $record->subtitle = trim($subtitle);
        $record->save();

        return $record;
    }

    /**
     * 用户积分流水列表
     *
     * @return array{items: array<int, array<string, mixed>>, total: int, page: int, limit: int}
     */
    public function listByUser(int $userId, int $page, int $limit): array
    {
        $this->assertUserExists($userId);

        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 15;

        $query = PointsLogModel::query()->where('user_id', $userId);
        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (PointsLogModel $log) => [
                'id' => (int) $log->id,
                'user_id' => (int) $log->user_id,
                'points' => (int) $log->points,
                'title' => (string) $log->title,
                'subtitle' => (string) $log->subtitle,
                'created_at' => $log->created_at
                    ? Carbon::parse((string) $log->created_at)->format('d M Y')
                    : '',
            ])
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    private function assertUserExists(int $userId): void
    {
        if (! UserModel::query()->where('id', $userId)->exists()) {
            throw new AppException('User does not exist');
        }
    }
}
