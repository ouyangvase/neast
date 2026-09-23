-- 协议管理菜单与 CRUD 按钮权限（可重复执行）

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
VALUES ('agreement', 'Agreement', 0, 'menu', '/agreement', 9, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:user', 'User Agreement', p.`id`, 'menu', '/agreement/user', 1, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'agreement'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:landlord', 'Landlord Agreement', p.`id`, 'menu', '/agreement/landlord', 2, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'agreement'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:merchant', 'Merchant Agreement', p.`id`, 'menu', '/agreement/merchant', 3, 1, NOW(), NOW()
FROM `t_permission` p
WHERE p.`code` = 'agreement'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `parent_id` = VALUES(`parent_id`),
  `path` = VALUES(`path`),
  `sort` = VALUES(`sort`),
  `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:user:create', 'Create', p.`id`, 'button', '', 1, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'agreement:user' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:user:update', 'Edit', p.`id`, 'button', '', 2, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'agreement:user' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:user:delete', 'Delete', p.`id`, 'button', '', 3, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'agreement:user' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:landlord:create', 'Create', p.`id`, 'button', '', 1, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'agreement:landlord' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:landlord:update', 'Edit', p.`id`, 'button', '', 2, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'agreement:landlord' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:landlord:delete', 'Delete', p.`id`, 'button', '', 3, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'agreement:landlord' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:merchant:create', 'Create', p.`id`, 'button', '', 1, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'agreement:merchant' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:merchant:update', 'Edit', p.`id`, 'button', '', 2, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'agreement:merchant' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();

INSERT INTO `t_permission` (`code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`)
SELECT 'agreement:merchant:delete', 'Delete', p.`id`, 'button', '', 3, 1, NOW(), NOW()
FROM `t_permission` p WHERE p.`code` = 'agreement:merchant' LIMIT 1
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`), `updated_at` = NOW();
