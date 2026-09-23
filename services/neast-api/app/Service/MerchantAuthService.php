<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Kit\Token;
use App\Model\MerchantModel;

class MerchantAuthService
{
    public const IDLE_TTL = 7200;

    public const JWT_TTL = 315360000;

    public const REFRESH_TTL = 2592000;

    /**
     * 商家邮箱 + 密码登录
     */
    public function login(string $account, string $password): array
    {
        $email = strtolower(trim($account));
        $password = trim($password);

        if ($email === '' || $password === '') {
            throw new AppException('Invalid account or password');
        }

        $merchant = MerchantModel::query()->where('email', $email)->first();
        if (! $merchant || ! password_verify($password, (string) $merchant->password)) {
            throw new AppException('Invalid account or password');
        }

        if ((int) $merchant->status !== 1) {
            throw new AppException('Account has been disabled');
        }

        return $this->issueTokens($merchant);
    }

    /**
     * 刷新 token
     */
    public function refresh(string $refreshToken): array
    {
        $refreshToken = trim($refreshToken);
        if ($refreshToken === '') {
            throw new AppException('Refresh token is required');
        }

        $merchantId = Token::get_merchant_refresh($refreshToken);
        if ($merchantId === null) {
            throw new AppException('Refresh token is invalid or expired');
        }

        $merchant = MerchantModel::query()->find((int) $merchantId);
        if (! $merchant) {
            Token::del_merchant_refresh($refreshToken);
            throw new AppException('Merchant does not exist');
        }

        if ((int) $merchant->status !== 1) {
            throw new AppException('Account has been disabled');
        }

        Token::del_merchant_refresh($refreshToken);
        Token::del_merchant_token($merchant->id);

        return $this->issueTokens($merchant);
    }

    /**
     * 获取当前登录商家信息
     */
    public function info(int $merchantId): array
    {
        $merchant = MerchantModel::query()->find($merchantId);
        if (! $merchant) {
            throw new AppException('Merchant not found');
        }

        $data = $merchant->toArray();
        if (! empty($data['image'])) {
            $data['image'] = env('APP_URL') . $data['image'];
        }

        return $data;
    }

    private function issueTokens(MerchantModel $merchant): array
    {
        $merchantData = [
            'id' => (int) $merchant->id,
            'email' => $merchant->email,
            'name' => $merchant->name,
        ];

        $accessToken = Token::createToken($merchantData, $merchant->id, 'merchant', self::JWT_TTL);
        Token::set_merchant_token($accessToken, $merchant->id, self::IDLE_TTL);

        $refreshToken = bin2hex(random_bytes(32));
        Token::set_merchant_refresh($refreshToken, $merchant->id, self::REFRESH_TTL);

        return [
            'accessToken' => $accessToken,
            'refreshToken' => $refreshToken,
            'expiresTime' => time() + self::IDLE_TTL,
            'merchantId' => (string) $merchant->id,
        ];
    }
}
