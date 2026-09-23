-- Rent History 结算按钮权限

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'rent:history:settle', 'Settle', p.`id`, 'button', '', 1, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'rent:history'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `type` = VALUES(`type`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();
