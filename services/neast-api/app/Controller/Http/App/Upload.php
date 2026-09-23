<?php

declare(strict_types=1);

namespace App\Controller\Http\App;

use App\Controller\AbstractController;
use App\Middleware\AppAuthMiddleware;
use App\Service\UploadService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

/**
 * App 端文件上传
 */
#[Controller(prefix: '/app/upload')]
class Upload extends AbstractController
{
    #[Inject]
    protected UploadService $service;

    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'file', methods: ['POST'])]
    public function file(RequestInterface $request): ResponseInterface
    {
        $file = $request->file('file');
        if (! $file) {
            return $this->error('File is required');
        }

        return $this->success($this->service->store($file));
    }

    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'chunk', methods: ['POST'])]
    public function chunk(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'upload_id' => 'required|string|min:8|max:64',
            'chunk_index' => 'required|integer|min:0',
            'total_chunks' => 'required|integer|min:1|max:100',
            'filename' => 'required|string|max:255',
        ], [
            'upload_id.required' => 'Upload id is required',
            'chunk_index.required' => 'Chunk index is required',
            'total_chunks.required' => 'Total chunks is required',
            'filename.required' => 'Filename is required',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        $file = $request->file('file');
        if (! $file) {
            return $this->error('Chunk file is required');
        }

        $this->service->storeChunk(
            (string) $request->input('upload_id'),
            (int) $request->input('chunk_index'),
            (int) $request->input('total_chunks'),
            (string) $request->input('filename'),
            $file
        );

        return $this->success();
    }

    #[Middleware(AppAuthMiddleware::class)]
    #[RequestMapping(path: 'merge', methods: ['POST'])]
    public function merge(RequestInterface $request): ResponseInterface
    {
        $validator = di(ValidatorFactory::class)->make($request->all(), [
            'upload_id' => 'required|string|min:8|max:64',
            'total_chunks' => 'required|integer|min:1|max:100',
            'filename' => 'required|string|max:255',
        ], [
            'upload_id.required' => 'Upload id is required',
            'total_chunks.required' => 'Total chunks is required',
            'filename.required' => 'Filename is required',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first());
        }

        return $this->success($this->service->mergeChunks(
            (string) $request->input('upload_id'),
            (int) $request->input('total_chunks'),
            (string) $request->input('filename'),
        ));
    }
}
