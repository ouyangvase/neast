-- 奖励等级维护权限（可重复执行）

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
VALUES ('reward:tier', 'Reward Tiers', 0, 'menu', '/reward-tier', 66, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'reward:tier:update', 'Save', p.`id`, 'button', '', 1, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'reward:tier'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `type` = VALUES(`type`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();
