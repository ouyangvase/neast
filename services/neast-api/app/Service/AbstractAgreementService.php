<?php

declare(strict_types=1);

namespace App\Service;

use App\Exception\AppException;
use App\Model\Model;
use Hyperf\HttpServer\Contract\RequestInterface;

abstract class AbstractAgreementService
{
    /**
     * @return class-string<Model>
     */
    abstract protected function getModelClass(): string;

    public function list(RequestInterface $request): array
    {
        $page = max(1, (int) $request->input('page', 1));
        $limit = (int) $request->input('limit', 15);
        $limit = $limit > 0 ? $limit : 15;
        $keyword = trim((string) $request->input('keyword', ''));

        $modelClass = $this->getModelClass();
        $query = $modelClass::query();

        if ($keyword !== '') {
            $query->where('title', 'like', "%{$keyword}%");
        }

        $total = (clone $query)->count();

        $items = $query->orderByDesc('id')
            ->forPage($page, $limit)
            ->get()
            ->map(fn (Model $item) => $item->toArray())
            ->all();

        return [
            'items' => $items,
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
        ];
    }

    /**
     * @param array<string, mixed> $params
     */
    public function create(array $params): array
    {
        [$title, $content] = $this->parsePayload($params);

        $modelClass = $this->getModelClass();
        $agreement = new $modelClass();
        $agreement->title = $title;
        $agreement->content = $content;
        $agreement->save();

        return $agreement->toArray();
    }

    /**
     * @param array<string, mixed> $params
     */
    public function update(int $id, array $params): array
    {
        $agreement = $this->findOrFail($id);
        [$title, $content] = $this->parsePayload($params);

        $agreement->title = $title;
        $agreement->content = $content;
        $agreement->save();

        return $agreement->toArray();
    }

    public function delete(int $id): void
    {
        $this->findOrFail($id)->delete();
    }

    /**
     * @return array<string, mixed>|null
     */
    public function findByTitle(string $title): ?array
    {
        $title = trim($title);
        if ($title === '') {
            return null;
        }

        $modelClass = $this->getModelClass();
        $agreement = $modelClass::query()
            ->where('title', $title)
            ->orderByDesc('id')
            ->first();

        return $agreement?->toArray();
    }

    /**
     * @return array{0: string, 1: string}
     */
    private function parsePayload(array $params): array
    {
        $title = trim((string) ($params['title'] ?? ''));
        $content = trim((string) ($params['content'] ?? ''));

        if ($title === '') {
            throw new AppException('Title is required');
        }

        if ($content === '') {
            throw new AppException('Content is required');
        }

        return [$title, $content];
    }

    private function findOrFail(int $id): Model
    {
        $modelClass = $this->getModelClass();
        $agreement = $modelClass::query()->find($id);
        if (! $agreement) {
            throw new AppException('Agreement not found');
        }

        return $agreement;
    }
}
