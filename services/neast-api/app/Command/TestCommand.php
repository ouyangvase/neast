<?php

declare(strict_types=1);

namespace App\Command;

use Hyperf\Command\Annotation\Command;
use Hyperf\Command\Command as HyperfCommand;
use Psr\Container\ContainerInterface;

#[Command]
class TestCommand extends HyperfCommand
{
    protected ?string $name = 'test';

    protected string $description = '预留调试命令（可改为本地 OpenSearch / 业务自测脚本）';

    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct();
    }

    public function handle(): void
    {
        $phone = '60143191523';
        $code = '321253';
        $this->send_sms($phone, $code);
        $this->info('No default test. Edit app/Command/TestCommand.php as needed.');
    }

        /**
     * 马来西亚bulk360短信发送
     */
    public function send_sms($phone, $code){
        $user = urlencode('yMYer3kaOB');
        $pass = urlencode('WZdscsL4GuigK3qvdzKyZXML6WVAU3SzQy7Hy8r3');
        $from = 'Neast';
        $url = 'https://sms.360.my/gw/bulk360/v3_0/send.php';
        $end_url = $url . '?user=' . $user . '&pass=' . $pass . '&form=' . $from;

        $text = 'Thanks for using Neast mobile app. Your verification code is ' . $code . '. Do not share your verification code with others.';

        $sen_url = $end_url . "&to=" . $phone . "&text=" . rawurlencode($text);
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $sen_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        $sentResult = curl_exec($ch);
        $sentResult = json_decode($sentResult, true);
        $code = $sentResult['code'] ?? 0;
        if ($code != 200) {
            return false;
        }
        curl_close($ch);
        return true;
    }
}
