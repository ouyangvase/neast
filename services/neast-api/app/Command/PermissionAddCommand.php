<?php

declare(strict_types=1);

namespace App\Command;

use App\Model\PermissionModel;
use Hyperf\Command\Annotation\Command;
use Hyperf\Command\Command as HyperfCommand;
use Psr\Container\ContainerInterface;
use Symfony\Component\Console\Input\InputOption;

/**
 * 添加（或更新）一条权限到 t_permission 表。
 *
 * 通过「上级权限 code」定位父级，避免依赖不稳定的自增 id。
 * 以 code 为唯一键，重复执行会更新该权限（幂等）。
 *
 * 使用示例：
 *   # 菜单（模块）
 *   php bin/hyperf.php permission:add --code=base --name=基础数据 --type=menu --path=/base
 *   # 菜单（页面，挂在模块下）
 *   php bin/hyperf.php permission:add --code=base:product --name=商品库 --parent=base --type=menu --path=/base/product
 *   # 按钮（挂在页面下）
 *   php bin/hyperf.php permission:add --code=base:product:create --name=新增商品 --parent=base:product --type=button
 */
#[Command]
class PermissionAddCommand extends HyperfCommand
{
    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct('permission:add');
    }

    public function configure()
    {
        parent::configure();
        $this->setDescription('添加/更新一条权限（菜单或按钮）到 t_permission');
        $this->addOption('code', null, InputOption::VALUE_REQUIRED, '权限码（唯一），如 base:product:create');
        $this->addOption('name', null, InputOption::VALUE_REQUIRED, '权限名称，如 新增商品');
        $this->addOption('parent', null, InputOption::VALUE_OPTIONAL, '上级权限 code（不传则为顶级）', '');
        $this->addOption('type', null, InputOption::VALUE_OPTIONAL, '类型 menu|button', 'menu');
        $this->addOption('path', null, InputOption::VALUE_OPTIONAL, '菜单路由路径（按钮留空）', '');
        $this->addOption('sort', null, InputOption::VALUE_OPTIONAL, '排序', '0');
    }

    public function handle()
    {
        $code = trim((string) $this->input->getOption('code'));
        $name = trim((string) $this->input->getOption('name'));
        $parentCode = trim((string) $this->input->getOption('parent'));
        $type = trim((string) $this->input->getOption('type')) ?: 'menu';
        $path = trim((string) $this->input->getOption('path'));
        $sort = (int) $this->input->getOption('sort');

        if ($code === '' || $name === '') {
            $this->error('--code 和 --name 为必填项');
            return;
        }
        if (! in_array($type, ['menu', 'button'], true)) {
            $this->error('--type 只能是 menu 或 button');
            return;
        }

        $parentId = 0;
        if ($parentCode !== '') {
            $parent = PermissionModel::query()->where('code', $parentCode)->first();
            if (! $parent) {
                $this->error("上级权限 code [{$parentCode}] 不存在，请先添加上级");
                return;
            }
            $parentId = (int) $parent->id;
        }

        $perm = PermissionModel::updateOrCreate(
            ['code' => $code],
            [
                'name' => $name,
                'parent_id' => $parentId,
                'type' => $type,
                'path' => $path,
                'sort' => $sort,
                'status' => 1,
            ]
        );

        $this->info("权限已登记: #{$perm->id} {$code} ({$type}, parent_id={$parentId})");
    }
}
