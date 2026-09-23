-- Users 证件编辑与修改记录按钮权限

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'user:update', 'Edit ID Document', p.`id`, 'button', '', 2, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'user'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `type` = VALUES(`type`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'user:change-log', 'Change Log', p.`id`, 'button', '', 3, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'user'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `type` = VALUES(`type`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();
