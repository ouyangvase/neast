-- 权限表 + 角色权限绑定字段
-- 权限不在页面做 CRUD，完全根据现有菜单手工写入

CREATE TABLE `t_permission` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限标志(唯一)',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '权限名称',
  `parent_id` int unsigned NOT NULL DEFAULT '0' COMMENT '上级权限ID',
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'menu' COMMENT '类型 menu菜单 button按钮',
  `path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '菜单路由路径',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态 0停用 1启用',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`) USING BTREE,
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='权限表';

-- 权限种子数据(系统管理：员工账号 + 角色管理)
INSERT INTO `t_permission` (`id`, `code`, `name`, `parent_id`, `type`, `path`, `sort`, `status`, `created_at`, `updated_at`) VALUES
(1, 'sys', 'System', 0, 'menu', '/system', 100, 1, NOW(), NOW()),
(2, 'sys:employee', 'Employees', 1, 'menu', '/system/account', 1, 1, NOW(), NOW()),
(3, 'sys:employee:create', 'Create', 2, 'button', '', 1, 1, NOW(), NOW()),
(4, 'sys:employee:update', 'Edit', 2, 'button', '', 2, 1, NOW(), NOW()),
(5, 'sys:employee:delete', 'Delete', 2, 'button', '', 3, 1, NOW(), NOW()),
(6, 'sys:employee:status', 'Toggle Status', 2, 'button', '', 4, 1, NOW(), NOW()),
(7, 'sys:employee:reset', 'Reset Password', 2, 'button', '', 5, 1, NOW(), NOW()),
(8, 'sys:role', 'Roles', 1, 'menu', '/system/role', 2, 1, NOW(), NOW()),
(9, 'sys:role:create', 'Create', 8, 'button', '', 1, 1, NOW(), NOW()),
(10, 'sys:role:update', 'Edit', 8, 'button', '', 2, 1, NOW(), NOW()),
(11, 'sys:role:delete', 'Delete', 8, 'button', '', 3, 1, NOW(), NOW());

-- 非超管角色初始化为空权限
UPDATE `t_admin_role` SET `permissions` = '[]' WHERE `code` <> 'ADMIN';
