<?php

declare(strict_types=1);

use Hyperf\AsyncQueue\Driver\DriverFactory;
use Hyperf\AsyncQueue\Job;
use Hyperf\Context\ApplicationContext;
use Psr\Container\ContainerInterface;

if (!function_exists('di')) {
    /**
     * 获取容器实例或从容器中获取实例
     *
     * @param string|null $id 如果传入id，则从容器中获取实例
     * @return mixed|ContainerInterface
     */
    function di(?string $id = null)
    {
        $container = ApplicationContext::getContainer();
        if (is_null($id)) {
            return $container;
        }
        return $container->get($id);
    }
}

if (!function_exists('queue')) {
    function queue(string $name = 'default')
    {
        return di(DriverFactory::class)->get($name);
    }
}

if (!function_exists('env')) {
    function env(string $key, mixed $default = null)
    {
        return Hyperf\Support\env($key, $default);
    }
}

if (!function_exists('file_url')) {
    /**
     * 将相对路径转为带 APP_URL 的完整访问地址
     */
    function file_url(?string $path): string
    {
        if ($path === null || $path === '') {
            return '';
        }

        if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://')) {
            return $path;
        }

        $baseUrl = rtrim((string) env('APP_URL', 'http://localhost:9512'), '/');

        return $baseUrl . (str_starts_with($path, '/') ? $path : '/' . $path);
    }
}

if (!function_exists('file_path')) {
    /**
     * 将完整 URL 或相对路径规范为数据库存储用的相对路径
     */
    function file_path(?string $value): string
    {
        if ($value === null || $value === '') {
            return '';
        }

        $value = trim($value);
        $baseUrl = rtrim((string) env('APP_URL', ''), '/');

        if ($baseUrl !== '' && str_starts_with($value, $baseUrl)) {
            $value = substr($value, strlen($baseUrl));
        }

        return str_starts_with($value, '/') ? $value : '/' . $value;
    }
}

if (! function_exists('payment_h5_base_url')) {
    /**
     * H5 支付页基址（可与 API APP_URL 不同）
     */
    function payment_h5_base_url(): string
    {
        $baseUrl = rtrim((string) env('PAYMENT_H5_BASE_URL', ''), '/');
        if ($baseUrl !== '') {
            return $baseUrl;
        }

        return rtrim((string) env('APP_URL', ''), '/');
    }
}