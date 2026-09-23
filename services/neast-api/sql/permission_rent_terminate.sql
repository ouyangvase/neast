-- Rent List 终止按钮权限

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'rent:list:terminate', 'Terminate', p.`id`, 'button', '', 2, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'rent:list'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `type` = VALUES(`type`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();
