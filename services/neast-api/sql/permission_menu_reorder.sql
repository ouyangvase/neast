-- 后台菜单重组：Rent 分组、Merchant 父子菜单、排序与权限码迁移
-- 可重复执行（以 code 为唯一键 upsert / 条件更新）

-- ---------------------------------------------------------------------------
-- 1. Rent 菜单
-- ---------------------------------------------------------------------------
INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
VALUES ('rent', 'Rent', 0, 'menu', '/rent', 3, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'rent:list', 'Rent List', p.`id`, 'menu', '/rent/list', 1, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'rent'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'rent:history', 'Rent History', p.`id`, 'menu', '/rent/history', 2, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'rent'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

-- ---------------------------------------------------------------------------
-- 2. Merchant 重组：父级分组 + 子菜单
-- ---------------------------------------------------------------------------
UPDATE `t_permission`
SET `path` = '/merchant', `sort` = 5, `updated_at` = NOW()
WHERE `code` = 'merchant';

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'merchant:list', 'Merchant List', p.`id`, 'menu', '/merchant/list', 1, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'merchant'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'merchant:bill', 'Bill', p.`id`, 'menu', '/merchant/bill', 2, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'merchant'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

-- Merchant 列表页按钮权限：merchant:* -> merchant:list:*
UPDATE `t_permission` p
INNER JOIN `t_permission` parent ON parent.`code` = 'merchant:list'
SET
  p.`code` = CASE p.`code`
    WHEN 'merchant:create' THEN 'merchant:list:create'
    WHEN 'merchant:update' THEN 'merchant:list:update'
    WHEN 'merchant:delete' THEN 'merchant:list:delete'
    WHEN 'merchant:status' THEN 'merchant:list:status'
    WHEN 'merchant:ledger' THEN 'merchant:list:ledger'
    WHEN 'merchant:points' THEN 'merchant:list:points'
    WHEN 'merchant:bills' THEN 'merchant:list:bills'
    ELSE p.`code`
  END,
  p.`parent_id` = parent.`id`,
  p.`updated_at` = NOW()
WHERE p.`code` IN (
  'merchant:create',
  'merchant:update',
  'merchant:delete',
  'merchant:status',
  'merchant:ledger',
  'merchant:points',
  'merchant:bills'
);

-- ---------------------------------------------------------------------------
-- 3. 顶级菜单排序（与侧边栏 order 一致）
-- ---------------------------------------------------------------------------
UPDATE `t_permission` SET `sort` = 1, `updated_at` = NOW() WHERE `code` = 'dashboard';
UPDATE `t_permission` SET `sort` = 2, `updated_at` = NOW() WHERE `code` = 'user';
UPDATE `t_permission` SET `sort` = 3, `updated_at` = NOW() WHERE `code` = 'rent';
UPDATE `t_permission` SET `sort` = 4, `updated_at` = NOW() WHERE `code` = 'landlord';
UPDATE `t_permission` SET `sort` = 5, `updated_at` = NOW() WHERE `code` = 'merchant';
UPDATE `t_permission` SET `sort` = 6, `updated_at` = NOW() WHERE `code` = 'coupon';
UPDATE `t_permission` SET `sort` = 7, `updated_at` = NOW() WHERE `code` = 'points:setting';
UPDATE `t_permission` SET `sort` = 8, `updated_at` = NOW() WHERE `code` = 'sys';

-- ---------------------------------------------------------------------------
-- 4. 非超管角色 permissions JSON 中的 merchant 按钮码迁移
-- ---------------------------------------------------------------------------
UPDATE `t_admin_role`
SET
  `permissions` = CAST(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                REPLACE(
                  CAST(`permissions` AS CHAR),
                  '"merchant:create"', '"merchant:list:create"'
                ),
                '"merchant:update"', '"merchant:list:update"'
              ),
              '"merchant:delete"', '"merchant:list:delete"'
            ),
            '"merchant:status"', '"merchant:list:status"'
          ),
          '"merchant:ledger"', '"merchant:list:ledger"'
        ),
        '"merchant:points"', '"merchant:list:points"'
      ),
      '"merchant:bills"', '"merchant:list:bills"'
    ) AS JSON
  ),
  `updated_at` = NOW()
WHERE `code` <> 'ADMIN'
  AND `permissions` IS NOT NULL;

-- 若角色原先仅有 merchant 页面权限、无父级 merchant，补全 merchant:list 以便访问列表页
UPDATE `t_admin_role`
SET
  `permissions` = JSON_ARRAY_APPEND(`permissions`, '$', 'merchant:list'),
  `updated_at` = NOW()
WHERE `code` <> 'ADMIN'
  AND JSON_CONTAINS(`permissions`, '"merchant"')
  AND NOT JSON_CONTAINS(`permissions`, '"merchant:list"');
