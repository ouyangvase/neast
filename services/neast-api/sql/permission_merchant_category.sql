-- 商家分类菜单与 CRUD 按钮权限（可重复执行）

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'merchant:category', 'Categories', p.`id`, 'menu', '/merchant/category', 3, 1, NOW(), NOW()
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
SELECT 'merchant:category:create', 'Create', p.`id`, 'button', '', 1, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'merchant:category' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'merchant:category:update', 'Edit', p.`id`, 'button', '', 2, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'merchant:category' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'merchant:category:delete', 'Delete', p.`id`, 'button', '', 3, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'merchant:category' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();
