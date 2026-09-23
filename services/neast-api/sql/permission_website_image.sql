-- 官网图片管理权限（可重复执行）

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
VALUES ('website-image', 'Website Images', 0, 'menu', '/website-image', 66, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'website-image:create', 'Create', p.`id`, 'button', '', 1, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'website-image'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `type` = VALUES(`type`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'website-image:update', 'Edit', p.`id`, 'button', '', 2, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'website-image'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `type` = VALUES(`type`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'website-image:delete', 'Delete', p.`id`, 'button', '', 3, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'website-image'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `type` = VALUES(`type`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();
