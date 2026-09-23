<?php

declare(strict_types=1);

use function Hyperf\Support\env;

$url = (string) env('OPENSEARCH_URL', '');
$hosts = [];
$primaryHost = '';
if ($url !== '') {
    $p = parse_url($url);
    if (!empty($p['host'])) {
        $scheme = $p['scheme'] ?? 'https';
        $port = isset($p['port']) ? (int) $p['port'] : ($scheme === 'https' ? 443 : 9200);
        $primaryHost = $p['host'];
        $hosts[] = [
            'host' => $primaryHost,
            'port' => $port,
            'scheme' => $scheme,
        ];
    }
}

$user = (string) env('OPENSEARCH_USER', '');

$region = (string) env('OPENSEARCH_REGION', env('AWS_REGION', ''));
if ($region === '' && $primaryHost !== '') {
    if (preg_match('/\.([a-z0-9-]+)\.es\.amazonaws\.com$/', $primaryHost, $m)) {
        $region = $m[1];
    }
}

$sigv4Env = env('OPENSEARCH_SIGV4');
if ($sigv4Env !== null) {
    $sigv4 = filter_var($sigv4Env, FILTER_VALIDATE_BOOLEAN);
} else {
    // 未显式配置时：配置了主用户/密码则走 Basic；否则在 AWS 托管域名上默认 IAM SigV4（避免未授权返回 HTML 导致 JSON 解析异常）
    $sigv4 = $user === '' && $primaryHost !== '' && str_contains($primaryHost, '.es.amazonaws.com');
}

return [
    'hosts' => $hosts,
    'username' => $user,
    'password' => (string) env('OPENSEARCH_PASSWORD', ''),
    'ssl_verification' => filter_var(env('OPENSEARCH_SSL_VERIFY', true), FILTER_VALIDATE_BOOLEAN),
    'sigv4' => $sigv4,
    'region' => $region,
    'sigv4_service' => (string) env('OPENSEARCH_SIGV4_SERVICE', 'es'),
    'include_port_in_host_header' => filter_var(env('OPENSEARCH_PORT_IN_HOST_HEADER', true), FILTER_VALIDATE_BOOLEAN),
];
