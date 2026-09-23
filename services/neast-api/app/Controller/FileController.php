<?php

declare(strict_types=1);

namespace App\Controller;

use Hyperf\HttpMessage\Stream\SwooleFileStream;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Psr\Http\Message\ResponseInterface;

/**
 * 静态文件访问
 */
#[Controller]
class FileController extends AbstractController
{
    #[RequestMapping(path: '/uploads/{path:.+}', methods: ['GET'])]
    public function uploads(string $path): ResponseInterface
    {
        if (str_contains($path, '..')) {
            return $this->response->raw('Not Found')->withStatus(404);
        }

        $filePath = BASE_PATH . '/public/uploads/' . $path;
        if (! is_file($filePath)) {
            return $this->response->raw('Not Found')->withStatus(404);
        }

        $mime = mime_content_type($filePath) ?: 'application/octet-stream';

        return $this->response
            ->withHeader('Content-Type', $mime)
            ->withBody(new SwooleFileStream($filePath));
    }
}
