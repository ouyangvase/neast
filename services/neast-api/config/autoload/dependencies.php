<?php

declare(strict_types=1);
/**
 * This file is part of Hyperf.
 *
 * @link     https://www.hyperf.io
 * @document https://hyperf.wiki
 * @contact  group@hyperf.io
 * @license  https://github.com/hyperf/hyperf/blob/master/LICENSE
 */

use Hyperf\Contract\ConfigInterface;
use Hyperf\Coroutine\Coroutine;
use Hyperf\Guzzle\RingPHP\CoroutineHandler;
use OpenSearch\Client;
use OpenSearch\ClientBuilder;
use Psr\Container\ContainerInterface;

return [
    Client::class => function (ContainerInterface $container) {
        /** @var ConfigInterface $config */
        $config = $container->get(ConfigInterface::class);
        $os = $config->get('opensearch', []);
        $hosts = $os['hosts'] ?? [];
        if ($hosts === []) {
            throw new \InvalidArgumentException('OpenSearch 未配置：请在 .env 中设置 OPENSEARCH_URL');
        }

        $builder = ClientBuilder::create();
        if (Coroutine::inCoroutine()) {
            $builder->setHandler(new CoroutineHandler());
        }

        $builder->setHosts($hosts);

        $user = (string) ($os['username'] ?? '');
        $useSigv4 = (bool) ($os['sigv4'] ?? false);

        if ($useSigv4 && $user !== '') {
            throw new \InvalidArgumentException('OpenSearch：不能同时启用 SigV4（OPENSEARCH_SIGV4）与主用户密码（OPENSEARCH_USER），请只保留一种认证方式');
        }

        if ($useSigv4) {
            $region = (string) ($os['region'] ?? '');
            if ($region === '') {
                throw new \InvalidArgumentException('OpenSearch SigV4 需要区域：请设置 OPENSEARCH_REGION 或 AWS_REGION，或使用 *.region.es.amazonaws.com 域名');
            }
            $builder->setSigV4CredentialProvider(true);
            $builder->setSigV4Region($region);
            $builder->setSigV4Service((string) ($os['sigv4_service'] ?? 'es'));
        } elseif ($user !== '') {
            $builder->setBasicAuthentication($user, (string) ($os['password'] ?? ''));
        }

        if (array_key_exists('ssl_verification', $os)) {
            $builder->setSSLVerification($os['ssl_verification']);
        }

        if ((bool) ($os['include_port_in_host_header'] ?? true)) {
            $builder->includePortInHostHeader(true);
        }

        return $builder->build();
    },
];
