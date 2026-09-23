<?php

declare(strict_types=1);

namespace App\Annotation;

use Attribute;
use Hyperf\Di\Annotation\AbstractAnnotation;

#[Attribute(Attribute::TARGET_CLASS | Attribute::TARGET_METHOD)]
class Auth extends AbstractAnnotation
{
    public function __construct(
        public string $scene = 'admin' // 可选参数，用于区分不同场景的验证，如 admin/api
    ) {
    }
} 