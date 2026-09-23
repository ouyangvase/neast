<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\UserModel;
use Carbon\Carbon;

class UserLocationService
{
    private const MIN_UPDATE_INTERVAL_SECONDS = 300;

    private const MIN_UPDATE_DISTANCE_METERS = 100;

    /**
     * 更新用户最后上报位置（dashboard 等入口调用）。
     */
    public function updateLastLocation(int $userId, float $latitude, float $longitude): void
    {
        if ($userId <= 0 || ! $this->isValidCoordinate($latitude, $longitude)) {
            return;
        }

        $user = UserModel::query()
            ->where('id', $userId)
            ->first(['id', 'last_latitude', 'last_longitude', 'last_location_at']);

        if ($user === null) {
            return;
        }

        if ($this->shouldSkipUpdate($user, $latitude, $longitude)) {
            return;
        }

        $now = date('Y-m-d H:i:s');

        UserModel::query()
            ->where('id', $userId)
            ->update([
                'last_latitude' => $latitude,
                'last_longitude' => $longitude,
                'last_location_at' => $now,
                'updated_at' => $now,
            ]);
    }

    /**
     * 查询指定半径内的启用用户，按距离升序。
     *
     * @return array<int, array{id: int, last_latitude: float|null, last_longitude: float|null, distance_m: float}>
     */
    public function findUsersWithinRadius(
        float $latitude,
        float $longitude,
        float $radiusKm = 20,
        int $limit = 500,
        ?Carbon $locationSince = null,
        int $offset = 0
    ): array {
        if (! $this->isValidCoordinate($latitude, $longitude) || $radiusKm <= 0 || $limit <= 0) {
            return [];
        }

        $radiusMeters = $radiusKm * 1000;
        [$minLat, $maxLat, $minLng, $maxLng] = $this->boundingBox($latitude, $longitude, $radiusKm);

        $query = UserModel::query()
            ->select([
                'id',
                'last_latitude',
                'last_longitude',
            ])
            ->selectRaw(
                'ST_Distance_Sphere(POINT(last_longitude, last_latitude), POINT(?, ?)) AS distance_m',
                [$longitude, $latitude]
            )
            ->where('status', 1)
            ->whereNotNull('last_latitude')
            ->whereNotNull('last_longitude')
            ->whereBetween('last_latitude', [$minLat, $maxLat])
            ->whereBetween('last_longitude', [$minLng, $maxLng])
            ->whereRaw(
                'ST_Distance_Sphere(POINT(last_longitude, last_latitude), POINT(?, ?)) <= ?',
                [$longitude, $latitude, $radiusMeters]
            );

        if ($locationSince !== null) {
            $query->where('last_location_at', '>=', $locationSince->format('Y-m-d H:i:s'));
        }

        if ($offset > 0) {
            $query->offset($offset);
        }

        return $query
            ->orderBy('distance_m')
            ->limit($limit)
            ->get()
            ->map(static function (UserModel $user): array {
                return [
                    'id' => (int) $user->id,
                    'last_latitude' => $user->last_latitude !== null ? (float) $user->last_latitude : null,
                    'last_longitude' => $user->last_longitude !== null ? (float) $user->last_longitude : null,
                    'distance_m' => round((float) ($user->distance_m ?? 0), 2),
                ];
            })
            ->values()
            ->all();
    }

    /**
     * @return array{0: float, 1: float, 2: float, 3: float}
     */
    private function boundingBox(float $latitude, float $longitude, float $radiusKm): array
    {
        $latDelta = $radiusKm / 111.0;
        $lngDelta = $radiusKm / (111.0 * max(cos(deg2rad($latitude)), 0.01));

        return [
            $latitude - $latDelta,
            $latitude + $latDelta,
            $longitude - $lngDelta,
            $longitude + $lngDelta,
        ];
    }

    private function isValidCoordinate(float $latitude, float $longitude): bool
    {
        return $latitude >= -90 && $latitude <= 90
            && $longitude >= -180 && $longitude <= 180;
    }

    private function shouldSkipUpdate(UserModel $user, float $latitude, float $longitude): bool
    {
        if ($user->last_latitude === null || $user->last_longitude === null || $user->last_location_at === null) {
            return false;
        }

        $lastLocationAt = Carbon::parse($user->last_location_at);
        if ($lastLocationAt->diffInSeconds(Carbon::now()) >= self::MIN_UPDATE_INTERVAL_SECONDS) {
            return false;
        }

        $distanceMeters = $this->haversineMeters(
            (float) $user->last_latitude,
            (float) $user->last_longitude,
            $latitude,
            $longitude
        );

        return $distanceMeters < self::MIN_UPDATE_DISTANCE_METERS;
    }

    private function haversineMeters(float $lat1, float $lng1, float $lat2, float $lng2): float
    {
        $earthRadius = 6371000.0;
        $latDelta = deg2rad($lat2 - $lat1);
        $lngDelta = deg2rad($lng2 - $lng1);

        $a = sin($latDelta / 2) ** 2
            + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * sin($lngDelta / 2) ** 2;
        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earthRadius * $c;
    }
}
