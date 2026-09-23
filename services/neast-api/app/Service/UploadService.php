<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use Hyperf\HttpMessage\Upload\UploadedFile;

use function Hyperf\Support\env;

class UploadService
{
    private const MAX_SIZE = 10 * 1024 * 1024;

    /**
     * 保存上传文件并返回可访问 URL
     */
    public function store(UploadedFile $file): array
    {
        if ($file->getError() !== UPLOAD_ERR_OK) {
            throw new AppException('File upload failed');
        }

        if ($file->getSize() > self::MAX_SIZE) {
            throw new AppException('File size exceeds 10MB');
        }

        $clientFilename = $file->getClientFilename();
        $extension = $this->resolveExtension($clientFilename);

        $uploadDir = BASE_PATH . '/public/uploads';
        if (! is_dir($uploadDir) && ! mkdir($uploadDir, 0755, true) && ! is_dir($uploadDir)) {
            throw new AppException('Failed to create upload directory');
        }

        $filename = date('Ymd') . '/' . uniqid('file_', true) . '.' . $extension;
        $targetPath = $uploadDir . '/' . $filename;
        $targetDir = dirname($targetPath);
        if (! is_dir($targetDir) && ! mkdir($targetDir, 0755, true) && ! is_dir($targetDir)) {
            throw new AppException('Failed to create upload directory');
        }

        $file->moveTo($targetPath);

        return $this->buildFileResult($filename, $clientFilename);
    }

    /**
     * 分片上传：保存单个分片
     */
    public function storeChunk(
        string $uploadId,
        int $chunkIndex,
        int $totalChunks,
        string $filename,
        UploadedFile $file
    ): void {
        $this->assertValidUploadId($uploadId);
        $this->assertValidChunkParams($chunkIndex, $totalChunks);
        $this->resolveExtension($filename);

        if ($file->getError() !== UPLOAD_ERR_OK) {
            throw new AppException('Chunk upload failed');
        }

        $chunkDir = $this->chunkDir($uploadId);
        if (! is_dir($chunkDir) && ! mkdir($chunkDir, 0755, true) && ! is_dir($chunkDir)) {
            throw new AppException('Failed to create chunk directory');
        }

        $metaPath = $chunkDir . '/meta.json';
        if (! is_file($metaPath)) {
            file_put_contents($metaPath, json_encode([
                'filename' => $filename,
                'total_chunks' => $totalChunks,
                'created_at' => time(),
            ], JSON_THROW_ON_ERROR));
        } else {
            $meta = json_decode((string) file_get_contents($metaPath), true, 512, JSON_THROW_ON_ERROR);
            if (($meta['filename'] ?? '') !== $filename || (int) ($meta['total_chunks'] ?? 0) !== $totalChunks) {
                throw new AppException('Chunk metadata mismatch');
            }
        }

        $file->moveTo($chunkDir . '/' . $chunkIndex);
    }

    /**
     * 分片上传：合并分片并返回最终文件信息
     *
     * @return array{url: string, path: string, name: string}
     */
    public function mergeChunks(string $uploadId, int $totalChunks, string $filename): array
    {
        $this->assertValidUploadId($uploadId);
        $this->assertValidChunkParams(0, $totalChunks);
        $extension = $this->resolveExtension($filename);

        $chunkDir = $this->chunkDir($uploadId);
        if (! is_dir($chunkDir)) {
            throw new AppException('Upload session not found');
        }

        $metaPath = $chunkDir . '/meta.json';
        if (! is_file($metaPath)) {
            throw new AppException('Upload session not found');
        }

        $meta = json_decode((string) file_get_contents($metaPath), true, 512, JSON_THROW_ON_ERROR);
        if (($meta['filename'] ?? '') !== $filename || (int) ($meta['total_chunks'] ?? 0) !== $totalChunks) {
            throw new AppException('Chunk metadata mismatch');
        }

        $totalSize = 0;
        for ($i = 0; $i < $totalChunks; ++$i) {
            $chunkPath = $chunkDir . '/' . $i;
            if (! is_file($chunkPath)) {
                throw new AppException('Missing chunk ' . $i);
            }
            $totalSize += (int) filesize($chunkPath);
        }

        if ($totalSize > self::MAX_SIZE) {
            $this->cleanupChunkDir($uploadId);
            throw new AppException('File size exceeds 10MB');
        }

        if ($totalSize <= 0) {
            $this->cleanupChunkDir($uploadId);
            throw new AppException('Empty file');
        }

        $uploadDir = BASE_PATH . '/public/uploads';
        if (! is_dir($uploadDir) && ! mkdir($uploadDir, 0755, true) && ! is_dir($uploadDir)) {
            throw new AppException('Failed to create upload directory');
        }

        $storedName = date('Ymd') . '/' . uniqid('file_', true) . '.' . $extension;
        $targetPath = $uploadDir . '/' . $storedName;
        $targetDir = dirname($targetPath);
        if (! is_dir($targetDir) && ! mkdir($targetDir, 0755, true) && ! is_dir($targetDir)) {
            throw new AppException('Failed to create upload directory');
        }

        $output = fopen($targetPath, 'wb');
        if ($output === false) {
            throw new AppException('Failed to merge chunks');
        }

        try {
            for ($i = 0; $i < $totalChunks; ++$i) {
                $chunkPath = $chunkDir . '/' . $i;
                $input = fopen($chunkPath, 'rb');
                if ($input === false) {
                    throw new AppException('Failed to read chunk ' . $i);
                }
                stream_copy_to_stream($input, $output);
                fclose($input);
            }
        } catch (\Throwable $e) {
            fclose($output);
            if (is_file($targetPath)) {
                unlink($targetPath);
            }
            throw $e instanceof AppException ? $e : new AppException('Failed to merge chunks');
        }

        fclose($output);
        $this->cleanupChunkDir($uploadId);

        return $this->buildFileResult($storedName, $filename);
    }

    private function resolveExtension(string $filename): string
    {
        $extension = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
        $extension = preg_replace('/[^a-z0-9]+/', '', $extension) ?? '';

        if ($extension === '') {
            return 'bin';
        }

        return strlen($extension) > 16 ? substr($extension, 0, 16) : $extension;
    }

    private function assertValidUploadId(string $uploadId): void
    {
        if ($uploadId === '' || ! preg_match('/^[a-zA-Z0-9_\-]{8,64}$/', $uploadId)) {
            throw new AppException('Invalid upload id');
        }
    }

    private function assertValidChunkParams(int $chunkIndex, int $totalChunks): void
    {
        if ($totalChunks < 1 || $totalChunks > 100) {
            throw new AppException('Invalid total chunks');
        }

        if ($chunkIndex < 0 || $chunkIndex >= $totalChunks) {
            throw new AppException('Invalid chunk index');
        }
    }

    private function chunkDir(string $uploadId): string
    {
        return BASE_PATH . '/runtime/chunk-uploads/' . $uploadId;
    }

    private function cleanupChunkDir(string $uploadId): void
    {
        $chunkDir = $this->chunkDir($uploadId);
        if (! is_dir($chunkDir)) {
            return;
        }

        $files = scandir($chunkDir);
        if ($files !== false) {
            foreach ($files as $file) {
                if ($file === '.' || $file === '..') {
                    continue;
                }
                $path = $chunkDir . '/' . $file;
                if (is_file($path)) {
                    unlink($path);
                }
            }
        }

        rmdir($chunkDir);
    }

    /**
     * @return array{url: string, path: string, name: string}
     */
    private function buildFileResult(string $storedRelativePath, string $originalName): array
    {
        $path = '/uploads/' . $storedRelativePath;

        return [
            'url' => file_url($path),
            'path' => $path,
            'name' => $originalName,
        ];
    }
}
