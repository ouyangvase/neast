<?php

declare(strict_types=1);

namespace App\Controller\Http\Admin;

use App\Controller\AbstractController;
use App\Middleware\AdminAuthMiddleware;
use App\Service\AbstractAgreementService;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Validation\ValidatorFactory;
use Psr\Http\Message\ResponseInterface;

abstract class AbstractAgreementController extends AbstractController
{
    abstract protected function agreementService(): AbstractAgreementService;

    #[RequestMapping(path: 'list', methods: ['GET'])]
    public function list(RequestInterface $request): ResponseInterface
    {
        return $this->success($this->agreementService()->list($request));
    }

    #[RequestMapping(path: 'create', methods: ['POST'])]
    public function create(RequestInterface $request): ResponseInterface
    {
        $params = $request->all();
        $error = $this->validatePayload($params);
        if ($error !== null) {
            return $this->error($error);
        }

        return $this->success($this->agreementService()->create($params));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['PUT'])]
    public function update(int $id, RequestInterface $request): ResponseInterface
    {
        $params = $request->all();
        $error = $this->validatePayload($params);
        if ($error !== null) {
            return $this->error($error);
        }

        return $this->success($this->agreementService()->update($id, $params));
    }

    #[RequestMapping(path: 'id/{id}', methods: ['DELETE'])]
    public function delete(int $id): ResponseInterface
    {
        $this->agreementService()->delete($id);

        return $this->success();
    }

    /**
     * @param array<string, mixed> $params
     */
    private function validatePayload(array $params): ?string
    {
        $validator = di(ValidatorFactory::class)->make($params, [
            'title' => 'required|string|max:255',
            'content' => 'required|string',
        ], [
            'title.required' => 'Please enter title',
            'title.max' => 'Title is too long',
            'content.required' => 'Please enter content',
        ]);

        if ($validator->fails()) {
            return $validator->errors()->first();
        }

        return null;
    }
}
