<?php

declare(strict_types=1);

namespace App\Middleware;

use Hyperf\HttpMessage\Exception\NotFoundHttpException;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

class NotFoundMiddleware implements MiddlewareInterface
{
    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        $dispatcher = $request->getAttribute('Hyperf\HttpServer\Router\Dispatched');
        if ($dispatcher && $dispatcher->status === 404) {
            throw new NotFoundHttpException();
        }
        return $handler->handle($request);
    }
} 