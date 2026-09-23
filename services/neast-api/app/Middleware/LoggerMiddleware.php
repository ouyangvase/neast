<?php

declare(strict_types=1);

namespace App\Middleware;

use Hyperf\Contract\StdoutLoggerInterface;
use Hyperf\Context\Context;
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

class LoggerMiddleware implements MiddlewareInterface
{
    public function __construct(
        protected ContainerInterface $container,
        protected StdoutLoggerInterface $logger
    ) {
    }

    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        // 记录请求开始时间
        $start = microtime(true);

        // 继续处理请求
        $response = $handler->handle($request);

        // 请求处理完后，计算耗时
        $end = microtime(true);
        $duration = number_format(($end - $start) * 1000, 2); // 毫秒

        $url = (string) $request->getUri();
        $method = $request->getMethod();
        $params = array_merge($request->getQueryParams(), $request->getParsedBody());

        $headers = $request->getHeaders();
        $not_need_headers = [
            "accept","accept-encoding","user-agent",
            "connection","content-type","cache-control","host","content-length",
            'x-amzn-trace-id', 'x-forwarded-port', 'x-forwarded-proto', 'x-forwarded-for',
            'priority', 'accept-language', 'referer', 'sec-fetch-dest', 'sec-fetch-mode', 
            'sec-fetch-site', 'origin', 'sec-ch-ua-mobile', 'sec-ch-ua'
        ];

        //不需要的header去掉
        foreach ($not_need_headers as $header) {
            if(isset($headers[$header])) {
                unset($headers[$header]);
            }
        }

        $auth = Context::get('auth') ?? [];

        $log_content = "======================". date('Y-m-d H:i:s') ."=========================\n";
        $log_content .= "Request to {$method} {$url} \n";
        $log_content .= "Auth ". json_encode($auth) ." \n";
        $log_content .= "Params " . json_encode($params, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES) . "\n";
        $log_content .= "Header " . json_encode($headers) . "\n";
        $log_content .= "Execution time: " . $duration . " ms\n";
        $log_content .= "=====================end==========================\n\n";

        // 写入日志
        $logPath = BASE_PATH . '/runtime/logs/request-'. date('Y-m-d') . '.log';
        file_put_contents($logPath, $log_content, FILE_APPEND);

        return $response;
        
    }
} 