-- 首页 Banner 管理权限（可重复执行）

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
VALUES ('banner', 'Banners', 0, 'menu', '/banner', 65, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'banner:create', 'Create', p.`id`, 'button', '', 1, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'banner'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `type` = VALUES(`type`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'banner:update', 'Edit', p.`id`, 'button', '', 2, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'banner'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `type` = VALUES(`type`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'banner:delete', 'Delete', p.`id`, 'button', '', 3, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'banner'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `type` = VALUES(`type`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();
