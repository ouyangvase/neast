<?php

declare(strict_types=1);

namespace App\Kit;

class RedisKey
{

    //后台token
    public static function admin_token($id) {
        return 'admin:'. $id.':token';
    }

    // App 用户 access token
    public static function user_token(string|int $id): string
    {
        return 'user:' . $id . ':token';
    }

    // App 用户 refresh token -> user id
    public static function user_refresh(string $refreshToken): string
    {
        return 'user:refresh:' . $refreshToken;
    }

    // App 登录验证码
    public static function app_auth_code(string $account): string
    {
        return 'app:auth:code:' . $account;
    }

    // App 用户删号验证码
    public static function app_user_delete_code(string $account): string
    {
        return 'app:user:delete-code:' . $account;
    }

    // 商家端 access token
    public static function merchant_token(string|int $id): string
    {
        return 'merchant:' . $id . ':token';
    }

    // 商家端 refresh token -> merchant id
    public static function merchant_refresh(string $refreshToken): string
    {
        return 'merchant:refresh:' . $refreshToken;
    }

    // 房东端 access token
    public static function landlord_token(string|int $id): string
    {
        return 'landlord:' . $id . ':token';
    }

    // 房东端 refresh token -> landlord id
    public static function landlord_refresh(string $refreshToken): string
    {
        return 'landlord:refresh:' . $refreshToken;
    }

    // 房东端登录验证码
    public static function landlord_auth_code(string $phone): string
    {
        return 'landlord:auth:code:' . $phone;
    }

    //短信验证码
    public static function sms_code($phone, $type) {
        return 'sms:code:' . $phone . ':' . $type;
    }

    //邮箱验证码
    public static function email_code($email, $type) {
        return 'email:code:' . $email . ':' . $type;
    }

    // IM：用户所有在线 fd 集合（支持多端登录）
    public static function im_member_fds(int $memberId): string
    {
        return 'im:member:' . $memberId . ':fds';
    }

    // IM：fd -> member_id 映射（用于断开时反查）
    public static function im_fd_member(int $fd): string
    {
        return 'im:fd:' . $fd . ':member';
    }

    // Airwallex：缓存的 API 访问令牌
    public static function airwallex_token(): string
    {
        return 'airwallex:access_token';
    }

    // Airwallex：order_no -> PaymentIntent id 映射（状态兜底查询用）
    public static function airwallex_intent(string $orderNo): string
    {
        return 'airwallex:intent:' . $orderNo;
    }

}
