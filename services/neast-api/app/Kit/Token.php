<?php

declare(strict_types=1);

namespace App\Kit;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Hyperf\Redis\Redis;
use Hyperf\Context\ApplicationContext;

class Token
{
    private static string $key = "hll-secret";
    private static string $alg = "HS256";
    private static string $keyId = "hll";

    /**
     * 创建 JWT token
     * @param mixed $data 自定义数据
     * @param string $id 用户ID
     * @param string $iss 发行者
     * @param int $expire 过期时间（秒）
     * @return string
     */
    public static function createToken(mixed $data, string|int $id, string $iss, int $expire = 7200): string
    {
        $payload = [
            'iss' => $iss,
            'sub' => $id,
            'iat' => time(),
            'exp' => time() + $expire,
            'data' => $data
        ];
        return JWT::encode($payload, self::$key, self::$alg, self::$keyId);
    }

    /**
     * 解析 JWT token
     * @param string $token
     * @return object|false
     */
    public static function decodeToken(string $token): object|false
    {
        try {
            $payload = JWT::decode($token, new Key(self::$key, self::$alg));
            return $payload;
        } catch(\Exception $e) {
            return false;
        }
    }

    /**
     * 获取 Redis 实例
     */
    private static function getRedis(): Redis
    {
        return ApplicationContext::getContainer()->get(Redis::class);
    }

    /**
     * 设置管理员 token
     */
    public static function set_admin_token(string $token, string|int $id, int $expire = 7200): void
    {
        self::getRedis()->setex(RedisKey::admin_token($id), $expire, $token);
    }

    /**
     * 获取管理员 token
     */
    public static function get_admin_token($id)
    {
        return self::getRedis()->get(RedisKey::admin_token($id));
    }

    /**
     * 刷新管理员 token 的过期时间（滑动续期）
     */
    public static function refresh_admin_token(string|int $id, int $expire = 7200): void
    {
        self::getRedis()->expire(RedisKey::admin_token($id), $expire);
    }

    /**
     * 删除管理员 token（登出）
     */
    public static function del_admin_token(string|int $id): void
    {
        self::getRedis()->del(RedisKey::admin_token($id));
    }

    /**
     * 设置 App 用户 access token
     */
    public static function set_user_token(string $token, string|int $id, int $expire = 7200): void
    {
        self::getRedis()->setex(RedisKey::user_token($id), $expire, $token);
    }

    /**
     * 获取 App 用户 access token
     */
    public static function get_user_token(string|int $id): ?string
    {
        $token = self::getRedis()->get(RedisKey::user_token($id));

        return $token === false ? null : $token;
    }

    /**
     * 刷新 App 用户 access token 过期时间
     */
    public static function refresh_user_token(string|int $id, int $expire = 7200): void
    {
        self::getRedis()->expire(RedisKey::user_token($id), $expire);
    }

    /**
     * 删除 App 用户 access token
     */
    public static function del_user_token(string|int $id): void
    {
        self::getRedis()->del(RedisKey::user_token($id));
    }

    /**
     * 设置 App refresh token
     */
    public static function set_user_refresh(string $refreshToken, string|int $userId, int $expire = 2592000): void
    {
        self::getRedis()->setex(RedisKey::user_refresh($refreshToken), $expire, (string) $userId);
    }

    /**
     * 获取 App refresh token 对应的用户 ID
     */
    public static function get_user_refresh(string $refreshToken): ?string
    {
        $userId = self::getRedis()->get(RedisKey::user_refresh($refreshToken));

        return $userId === false ? null : $userId;
    }

    /**
     * 删除 App refresh token
     */
    public static function del_user_refresh(string $refreshToken): void
    {
        self::getRedis()->del(RedisKey::user_refresh($refreshToken));
    }

    /**
     * 设置商家 access token
     */
    public static function set_merchant_token(string $token, string|int $id, int $expire = 7200): void
    {
        self::getRedis()->setex(RedisKey::merchant_token($id), $expire, $token);
    }

    /**
     * 获取商家 access token
     */
    public static function get_merchant_token(string|int $id): ?string
    {
        $token = self::getRedis()->get(RedisKey::merchant_token($id));

        return $token === false ? null : $token;
    }

    /**
     * 刷新商家 access token 过期时间
     */
    public static function refresh_merchant_token(string|int $id, int $expire = 7200): void
    {
        self::getRedis()->expire(RedisKey::merchant_token($id), $expire);
    }

    /**
     * 删除商家 access token
     */
    public static function del_merchant_token(string|int $id): void
    {
        self::getRedis()->del(RedisKey::merchant_token($id));
    }

    /**
     * 设置商家 refresh token
     */
    public static function set_merchant_refresh(string $refreshToken, string|int $merchantId, int $expire = 2592000): void
    {
        self::getRedis()->setex(RedisKey::merchant_refresh($refreshToken), $expire, (string) $merchantId);
    }

    /**
     * 获取商家 refresh token 对应的商家 ID
     */
    public static function get_merchant_refresh(string $refreshToken): ?string
    {
        $merchantId = self::getRedis()->get(RedisKey::merchant_refresh($refreshToken));

        return $merchantId === false ? null : $merchantId;
    }

    /**
     * 删除商家 refresh token
     */
    public static function del_merchant_refresh(string $refreshToken): void
    {
        self::getRedis()->del(RedisKey::merchant_refresh($refreshToken));
    }

    /**
     * 设置房东 access token
     */
    public static function set_landlord_token(string $token, string|int $id, int $expire = 7200): void
    {
        self::getRedis()->setex(RedisKey::landlord_token($id), $expire, $token);
    }

    /**
     * 获取房东 access token
     */
    public static function get_landlord_token(string|int $id): ?string
    {
        $token = self::getRedis()->get(RedisKey::landlord_token($id));

        return $token === false ? null : $token;
    }

    /**
     * 刷新房东 access token 过期时间
     */
    public static function refresh_landlord_token(string|int $id, int $expire = 7200): void
    {
        self::getRedis()->expire(RedisKey::landlord_token($id), $expire);
    }

    /**
     * 删除房东 access token
     */
    public static function del_landlord_token(string|int $id): void
    {
        self::getRedis()->del(RedisKey::landlord_token($id));
    }

    /**
     * 设置房东 refresh token
     */
    public static function set_landlord_refresh(string $refreshToken, string|int $landlordId, int $expire = 2592000): void
    {
        self::getRedis()->setex(RedisKey::landlord_refresh($refreshToken), $expire, (string) $landlordId);
    }

    /**
     * 获取房东 refresh token 对应的房东 ID
     */
    public static function get_landlord_refresh(string $refreshToken): ?string
    {
        $landlordId = self::getRedis()->get(RedisKey::landlord_refresh($refreshToken));

        return $landlordId === false ? null : $landlordId;
    }

    /**
     * 删除房东 refresh token
     */
    public static function del_landlord_refresh(string $refreshToken): void
    {
        self::getRedis()->del(RedisKey::landlord_refresh($refreshToken));
    }
}
