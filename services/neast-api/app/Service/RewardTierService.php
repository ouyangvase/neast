<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\RewardTierModel;
use Hyperf\DbConnection\Db;

class RewardTierService
{
    public const TIER_COUNT = 5;

    /**
     * 全部等级（按 id 升序）
     *
     * @return array<int, array<string, mixed>>
     */
    public function all(): array
    {
        return RewardTierModel::query()
            ->orderBy('id')
            ->get()
            ->map(fn (RewardTierModel $tier) => $this->formatTier($tier))
            ->all();
    }

    /**
     * 后台等级列表（固定 5 条）
     *
     * @return array<string, mixed>
     */
    public function adminList(): array
    {
        $items = $this->all();
        if (count($items) !== self::TIER_COUNT) {
            throw new AppException('Reward tiers must contain exactly ' . self::TIER_COUNT . ' records');
        }

        return ['items' => $items];
    }

    /**
     * 后台批量更新等级（固定 5 条，积分区间必须连续）
     *
     * @param array<int, array<string, mixed>> $items
     * @return array<string, mixed>
     */
    public function adminUpdateAll(array $items): array
    {
        $normalized = $this->normalizeAdminItems($items);
        $this->validateAdminItems($normalized);

        Db::transaction(function () use ($normalized): void {
            foreach ($normalized as $item) {
                $tier = RewardTierModel::query()->find((int) $item['id']);
                if (! $tier) {
                    throw new AppException('Reward tier not found: ' . $item['id']);
                }

                $tier->name = (string) $item['name'];
                $tier->min_points = (int) $item['min_points'];
                $tier->max_points = (int) $item['max_points'];
                $tier->save();
            }
        });

        return $this->adminList();
    }

    /**
     * 根据积分解析当前等级与下一等级进度
     *
     * @return array<string, mixed>
     */
    public function resolve(int $pointsBalance): array
    {
        $tiers = RewardTierModel::query()->orderBy('id')->get();
        $current = $this->findTierForPoints($tiers, $pointsBalance);

        if ($current === null) {
            $current = $tiers->first();
        }

        $next = $tiers->firstWhere('id', (int) $current->id + 1);

        $progressCurrent = $pointsBalance;
        $pointsToNextTier = 0;
        $progressTarget = (int) $current->max_points;

        if ($next instanceof RewardTierModel) {
            $pointsToNextTier = max(0, (int) $next->min_points - $pointsBalance);
            $progressTarget = (int) $next->min_points;
        } else {
            // 已达最高等级：进度条满格
            $progressTarget = $progressCurrent;
        }

        return [
            'current' => $this->formatTier($current),
            'next' => $next instanceof RewardTierModel ? $this->formatTier($next) : null,
            'pointsToNextTier' => $pointsToNextTier,
            'progressCurrent' => $progressCurrent,
            'progressTarget' => $progressTarget,
        ];
    }

    /**
     * @param iterable<RewardTierModel> $tiers
     */
    private function findTierForPoints(iterable $tiers, int $pointsBalance): ?RewardTierModel
    {
        $highestTier = null;

        foreach ($tiers as $tier) {
            $highestTier = $tier;
            if ($pointsBalance >= (int) $tier->min_points
                && $pointsBalance <= (int) $tier->max_points) {
                return $tier;
            }
        }

        if ($highestTier !== null
            && $pointsBalance >= (int) $highestTier->min_points) {
            return $highestTier;
        }

        return null;
    }

    /**
     * @return array<string, mixed>
     */
    private function formatTier(RewardTierModel $tier): array
    {
        return [
            'id' => (int) $tier->id,
            'name' => (string) $tier->name,
            'min_points' => (int) $tier->min_points,
            'max_points' => (int) $tier->max_points,
        ];
    }

    /**
     * @param array<int, array<string, mixed>> $items
     * @return array<int, array<string, mixed>>
     */
    private function normalizeAdminItems(array $items): array
    {
        if (count($items) !== self::TIER_COUNT) {
            throw new AppException('Please provide exactly ' . self::TIER_COUNT . ' reward tiers');
        }

        $normalized = [];
        foreach ($items as $item) {
            if (! is_array($item)) {
                throw new AppException('Invalid reward tier payload');
            }

            $id = (int) ($item['id'] ?? 0);
            if ($id < 1 || $id > self::TIER_COUNT) {
                throw new AppException('Invalid reward tier id');
            }

            $normalized[] = [
                'id' => $id,
                'name' => trim((string) ($item['name'] ?? '')),
                'min_points' => (int) ($item['min_points'] ?? -1),
                'max_points' => (int) ($item['max_points'] ?? -1),
            ];
        }

        usort($normalized, fn (array $a, array $b) => $a['id'] <=> $b['id']);

        for ($index = 0; $index < self::TIER_COUNT; ++$index) {
            if ($normalized[$index]['id'] !== $index + 1) {
                throw new AppException('Reward tier ids must be 1 to ' . self::TIER_COUNT);
            }
        }

        return $normalized;
    }

    /**
     * @param array<int, array<string, mixed>> $items
     */
    private function validateAdminItems(array $items): void
    {
        foreach ($items as $index => $item) {
            if ($item['name'] === '') {
                throw new AppException('Tier ' . $item['id'] . ': name is required');
            }

            if ($item['min_points'] < 0) {
                throw new AppException('Tier ' . $item['id'] . ': min points cannot be negative');
            }

            if ($item['max_points'] < $item['min_points']) {
                throw new AppException('Tier ' . $item['id'] . ': max points must be greater than or equal to min points');
            }

            if ($index === 0) {
                if ($item['min_points'] !== 0) {
                    throw new AppException('Tier 1 min points must start from 0');
                }

                continue;
            }

            $previous = $items[$index - 1];
            $expectedMin = (int) $previous['max_points'] + 1;
            if ($item['min_points'] !== $expectedMin) {
                throw new AppException(
                    'Tier ' . $item['id'] . ': min points must be ' . $expectedMin
                    . ' (previous tier max points + 1)'
                );
            }
        }
    }
}
