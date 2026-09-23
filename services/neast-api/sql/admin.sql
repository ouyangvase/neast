-- 员工(管理员)与角色相关表
-- DB_PREFIX 为空,表名直接含 t_ 前缀

CREATE TABLE `t_admin_role` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '角色名称',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '角色编码',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `permissions` json NULL COMMENT '权限code数组',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态 0停用 1启用',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='管理员角色表';

CREATE TABLE `t_admin` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '头像',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录账号',
  `real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '员工姓名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '密码哈希',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '联系电话',
  `role_id` int unsigned NOT NULL DEFAULT '0' COMMENT '角色ID',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态 0停用 1启用',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`) USING BTREE,
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='管理员(员工)表';

-- 角色种子数据
INSERT INTO `t_admin_role` (`id`, `name`, `code`, `description`, `status`, `created_at`, `updated_at`) VALUES
(1, '超级管理员', 'ADMIN', '系统最高权限，可管理所有模块', 1, NOW(), NOW()),
(2, '财务经理', 'FINANCE_MGR', '负责财务审核与账单管理', 1, NOW(), NOW()),
(3, '业务主管', 'SALES_LEAD', '管理业务订单与客户资源', 1, NOW(), NOW()),
(4, '操作员', 'OPERATOR', '负责录单与单据维护', 1, NOW(), NOW());

-- 默认管理员账号(密码: aaa123456)
INSERT INTO `t_admin` (`username`, `real_name`, `password`, `email`, `phone`, `role_id`, `status`, `created_at`, `updated_at`) VALUES
('admin', '系统管理员', '$2y$10$JSoYbIoJTmF.fG.ysBmhm.bpZDrayrn6NM7f3Zk7/syceZFFte5Wi', 'admin@baimiyun.com', '13800138000', 1, 1, NOW(), NOW());
