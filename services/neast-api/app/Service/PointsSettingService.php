<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\PointsSettingModel;

class PointsSettingService
{
    /**
     * 获取积分设置
     */
    public function get(): array
    {
        return $this->getOrCreate()->toArray();
    }

    /**
     * 更新积分设置
     */
    public function update(array $params): array
    {
        $setting = $this->getOrCreate();
        $setting->rent_points_multiplier = $this->formatMultiplier($params['rent_points_multiplier'] ?? '1');
        $setting->spend_points_multiplier = $this->formatMultiplier($params['spend_points_multiplier'] ?? '1');
        $setting->yuan_to_points = (int) ($params['yuan_to_points'] ?? 1);
        $setting->inviter_reward_points = (int) ($params['inviter_reward_points'] ?? 0);
        $setting->invitee_reward_points = (int) ($params['invitee_reward_points'] ?? 0);
        $setting->save();

        return $setting->toArray();
    }

    private function getOrCreate(): PointsSettingModel
    {
        $setting = PointsSettingModel::query()->find(PointsSettingModel::SINGLETON_ID);
        if ($setting) {
            return $setting;
        }

        $setting = new PointsSettingModel();
        $setting->id = PointsSettingModel::SINGLETON_ID;
        $setting->rent_points_multiplier = '1.0';
        $setting->spend_points_multiplier = '1.0';
        $setting->yuan_to_points = 100;
        $setting->inviter_reward_points = 0;
        $setting->invitee_reward_points = 0;
        $setting->save();

        return $setting;
    }

    private function formatMultiplier(mixed $value): string
    {
        return number_format((float) $value, 1, '.', '');
    }
}
