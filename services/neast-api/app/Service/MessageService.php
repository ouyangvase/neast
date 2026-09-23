<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\LandlordMessageModel;
use App\Model\MerchantMessageModel;
use App\Model\Model;
use App\Model\UserMessageModel;
use Hyperf\Database\Model\Builder;

class MessageService
{
    public function userList(int $userId, int $page, int $limit): array
    {
        $query = UserMessageModel::query()->where('user_id', $userId);

        return $this->paginate($query, $page, $limit);
    }

    public function userMarkAllRead(int $userId): void
    {
        UserMessageModel::query()
            ->where('user_id', $userId)
            ->where('is_read', 0)
            ->update(['is_read' => 1]);
    }

    public function userHasUnread(int $userId): bool
    {
        return UserMessageModel::query()
            ->where('user_id', $userId)
            ->where('is_read', 0)
            ->exists();
    }

    public function landlordList(int $landlordId, int $page, int $limit): array
    {
        $query = LandlordMessageModel::query()->where('landlord_id', $landlordId);

        return $this->paginate($query, $page, $limit);
    }

    public function landlordMarkAllRead(int $landlordId): void
    {
        LandlordMessageModel::query()
            ->where('landlord_id', $landlordId)
            ->where('is_read', 0)
            ->update(['is_read' => 1]);
    }

    public function landlordHasUnread(int $landlordId): bool
    {
        return LandlordMessageModel::query()
            ->where('landlord_id', $landlordId)
            ->where('is_read', 0)
            ->exists();
    }

    public function merchantList(int $merchantId, int $page, int $limit): array
    {
        $query = MerchantMessageModel::query()->where('merchant_id', $merchantId);

        return $this->paginate($query, $page, $limit);
    }

    public function merchantMarkAllRead(int $merchantId): void
    {
        MerchantMessageModel::query()
            ->where('merchant_id', $merchantId)
            ->where('is_read', 0)
            ->update(['is_read' => 1]);
    }

    public function createUserMessage(int $userId, string $title, string $content): void
    {
        if ($userId <= 0) {
            return;
        }

        UserMessageModel::query()->create([
            'user_id' => $userId,
            'title' => $title,
            'content' => $content,
            'is_read' => 0,
        ]);
    }

    /**
     * @param array<int, int> $userIds
     */
    public function createUserMessagesBatch(array $userIds, string $title, string $content): void
    {
        $userIds = array_values(array_unique(array_filter(
            $userIds,
            static fn (int $userId): bool => $userId > 0
        )));

        if ($userIds === []) {
            return;
        }

        $now = date('Y-m-d H:i:s');
        $rows = array_map(static fn (int $userId): array => [
            'user_id' => $userId,
            'title' => $title,
            'content' => $content,
            'is_read' => 0,
            'created_at' => $now,
            'updated_at' => $now,
        ], $userIds);

        UserMessageModel::query()->insert($rows);
    }

    public function createMerchantMessage(int $merchantId, string $title, string $content): void
    {
        if ($merchantId <= 0) {
            return;
        }

        MerchantMessageModel::query()->create([
            'merchant_id' => $merchantId,
            'title' => $title,
            'content' => $content,
            'is_read' => 0,
        ]);
    }

    public function createLandlordMessage(int $landlordId, string $title, string $content): void
    {
        if ($landlordId <= 0) {
            return;
        }

        LandlordMessageModel::query()->create([
            'landlord_id' => $landlordId,
            'title' => $title,
            'content' => $content,
            'is_read' => 0,
        ]);
    }

    /**
     * @param Builder<Model> $query
     */
    private function paginate(Builder $query, int $page, int $limit): array
    {
        $page = max(1, $page);
        $limit = $limit > 0 ? $limit : 15;

        $total = (clone $query)->count();

        $items = $query
            ->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (Model $message) => $this->formatItem($message))
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    private function formatItem(Model $message): array
    {
        return [
            'id' => (int) $message->id,
            'title' => (string) $message->title,
            'content' => (string) $message->content,
            'is_read' => (int) $message->is_read,
            'created_at' => $message->created_at?->format('Y-m-d H:i:s') ?? '',
        ];
    }
}
