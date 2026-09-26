<?php

declare(strict_types=1);

namespace App\Controller;

use App\Exception\AppException;
use App\Service\WalletService;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Psr\Http\Message\ResponseInterface;

use function Hyperf\Support\env;

/**
 * Fiuu H5 支付公开页与回调
 */
#[Controller]
class PaymentH5Controller extends AbstractController
{
    #[Inject]
    protected WalletService $walletService;

    #[RequestMapping(path: '/pay.html', methods: ['GET'])]
    public function payPage(RequestInterface $request): ResponseInterface
    {
        if ((string) env('APP_ENV', 'dev') !== 'dev') {
            return $this->renderHtml('pay.html');
        }

        $orderId = trim((string) $request->input('order_sn', ''));
        $channel = trim((string) $request->input('code', ''));

        try {
            $amount = $this->walletService->devOrderAmount($orderId);
        } catch (AppException $exception) {
            return $this->response->raw($exception->getMessage())->withStatus(404);
        }

        return $this->renderDevPayPage($amount, $orderId, $channel);
    }

    #[RequestMapping(path: '/wallet/topup/dev-return', methods: ['POST'])]
    public function devReturn(RequestInterface $request): ResponseInterface
    {
        if ((string) env('APP_ENV', 'dev') !== 'dev') {
            return $this->response->raw('Not Found')->withStatus(404);
        }

        $orderId = trim((string) $request->input('order_sn', ''));
        $channel = trim((string) $request->input('code', ''));

        try {
            $this->walletService->settleDevOrder($orderId, $channel);
        } catch (AppException $exception) {
            return $this->response->raw($exception->getMessage())->withStatus(400);
        }

        return $this->response->redirect(payment_h5_base_url() . '/pay_success.html');
    }

    #[RequestMapping(path: '/pay_success.html', methods: ['GET'])]
    public function paySuccessPage(): ResponseInterface
    {
        return $this->renderHtml('pay_success.html');
    }

    #[RequestMapping(path: '/pay_pending.html', methods: ['GET'])]
    public function payPendingPage(): ResponseInterface
    {
        return $this->renderHtml('pay_pending.html');
    }

    #[RequestMapping(path: '/pay_failed.html', methods: ['GET'])]
    public function payFailedPage(): ResponseInterface
    {
        return $this->renderHtml('pay_failed.html');
    }

    /**
     * MOLPay Seamless：返回 JSON 表单字段（不包 success 壳）。
     */
    #[RequestMapping(path: '/payOrder', methods: ['GET', 'POST', 'HEAD'])]
    public function payOrder(RequestInterface $request): ResponseInterface
    {
        $orderNo = trim((string) $request->input('order_no', ''));
        $channel = trim((string) $request->input('payment_options', ''));

        try {
            $data = $this->walletService->buildH5PayForm($orderNo, $channel);
        } catch (AppException $exception) {
            return $this->response->json([
                'status' => false,
                'error_desc' => $exception->getMessage(),
            ]);
        }

        return $this->response->json($data);
    }

    #[RequestMapping(path: '/wallet/topup/notify', methods: ['GET', 'POST', 'HEAD'])]
    public function notify(RequestInterface $request): ResponseInterface
    {
        $result = $this->walletService->handleH5Notify($request->all());

        return $this->response->raw($result);
    }

    #[RequestMapping(path: '/wallet/topup/return', methods: ['GET', 'POST', 'HEAD'])]
    public function paymentReturn(RequestInterface $request): ResponseInterface
    {
        $status = $this->walletService->resolveH5ReturnStatus($request->all());
        $appUrl = payment_h5_base_url();

        $target = match ($status) {
            'success' => $appUrl . '/pay_success.html',
            'pending' => $appUrl . '/pay_pending.html',
            default => $appUrl . '/pay_failed.html',
        };

        return $this->response->redirect($target);
    }

    private function renderDevPayPage(string $amount, string $orderId, string $channel): ResponseInterface
    {
        $templatePath = BASE_PATH . '/storage/html/pay_dev.html';
        if (! is_file($templatePath)) {
            return $this->response->raw('Not Found')->withStatus(404);
        }

        $html = str_replace(
            ['__AMOUNT__', '__ORDER_SN__', '__CHANNEL__'],
            [
                htmlspecialchars($amount, ENT_QUOTES, 'UTF-8'),
                htmlspecialchars($orderId, ENT_QUOTES, 'UTF-8'),
                htmlspecialchars($channel, ENT_QUOTES, 'UTF-8'),
            ],
            (string) file_get_contents($templatePath)
        );

        return $this->response
            ->raw($html)
            ->withHeader('Content-Type', 'text/html; charset=utf-8');
    }

    private function renderHtml(string $filename): ResponseInterface
    {
        $templatePath = BASE_PATH . '/storage/html/' . $filename;
        if (! is_file($templatePath)) {
            return $this->response->raw('Not Found')->withStatus(404);
        }

        $html = (string) file_get_contents($templatePath);

        return $this->response
            ->raw($html)
            ->withHeader('Content-Type', 'text/html; charset=utf-8');
    }
}
