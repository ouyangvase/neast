<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\UserModel;
use Carbon\Carbon;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Contract\RequestInterface;

class UserService
{
    #[Inject]
    protected UserChangeLogService $changeLogService;

    #[Inject]
    protected UserPointsService $userPointsService;

    /**
     * 用户列表（关键词/状态筛选、分页）
     */
    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;

        $keyword = trim((string) $request->input('keyword', ''));
        $status = $request->input('status', null);

        $query = UserModel::query();

        if ($keyword !== '') {
            $query->where(function ($q) use ($keyword) {
                $q->where('first_name', 'like', "%{$keyword}%")
                    ->orWhere('last_name', 'like', "%{$keyword}%")
                    ->orWhere('account', 'like', "%{$keyword}%")
                    ->orWhere('email', 'like', "%{$keyword}%")
                    ->orWhere('id_number', 'like', "%{$keyword}%")
                    ->orWhere('invitation_code', 'like', "%{$keyword}%");
            });
        }

        if ($status !== null && $status !== '') {
            $query->where('status', (int) $status);
        }

        $total = (clone $query)->count();

        $items = $query->orderBy('id', 'desc')
            ->forPage($page, $limit)
            ->get()
            ->toArray();

        $userIds = array_map(static fn (array $item) => (int) ($item['id'] ?? 0), $items);
        $pointsMap = $this->userPointsService->availableBalancesForUsers($userIds);

        foreach ($items as &$item) {
            $userId = (int) ($item['id'] ?? 0);
            $item['points'] = $pointsMap[$userId] ?? 0;
        }
        unset($item);

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * 状态切换
     */
    public function toggleStatus(int $id, int $status): void
    {
        $user = $this->findOrFail($id);
        $user->status = $status === 1 ? 1 : 0;
        $user->save();
    }

    /**
     * 后台编辑用户证件信息
     *
     * @param array<string, mixed> $params
     */
    public function updateIdDocument(int $id, array $params, int $adminId): void
    {
        if ($adminId <= 0) {
            throw new AppException('Admin not found');
        }

        $user = $this->findOrFail($id);

        $idType = trim((string) ($params['id_type'] ?? ''));
        $idNumber = trim((string) ($params['id_number'] ?? ''));
        $idValidUntil = trim((string) ($params['id_valid_until'] ?? ''));

        if (! in_array($idType, [UserModel::ID_TYPE_ID_CARD, UserModel::ID_TYPE_PASSPORT], true)) {
            throw new AppException('Invalid ID document type');
        }

        if ($idNumber === '') {
            throw new AppException('Please enter ID number');
        }

        if ($idType === UserModel::ID_TYPE_ID_CARD) {
            if ($idValidUntil === '') {
                throw new AppException('Please select the valid until date');
            }
            $idValidUntil = $this->formatDate($idValidUntil) ?? '';
            if ($idValidUntil === '') {
                throw new AppException('Invalid valid until date');
            }
        } else {
            $idValidUntil = '';
        }

        $before = $this->snapshotIdDocument($user);
        $after = [
            'id_type' => $idType,
            'id_number' => $idNumber,
            'id_valid_until' => $idValidUntil !== '' ? $idValidUntil : null,
        ];

        if ($before === $after) {
            return;
        }

        Db::transaction(function () use ($user, $after, $before, $adminId, $id) {
            $user->id_type = $after['id_type'];
            $user->id_number = $after['id_number'];
            $user->id_valid_until = $after['id_valid_until'];
            $user->save();

            $this->changeLogService->record($id, $before, $after, $adminId);
        });
    }

    /**
     * @return array{id_type: string, id_number: string, id_valid_until: string|null}
     */
    private function snapshotIdDocument(UserModel $user): array
    {
        return [
            'id_type' => (string) $user->id_type,
            'id_number' => (string) $user->id_number,
            'id_valid_until' => $this->formatDate($user->id_valid_until),
        ];
    }

    private function formatDate(mixed $value): ?string
    {
        if ($value === null || $value === '') {
            return null;
        }

        try {
            return Carbon::parse((string) $value)->format('Y-m-d');
        } catch (\Throwable) {
            return null;
        }
    }

    private function findOrFail(int $id): UserModel
    {
        $user = UserModel::query()->find($id);
        if (! $user) {
            throw new AppException('User not found');
        }

        return $user;
    }
}
