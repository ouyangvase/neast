-- 用户证件信息修改记录

CREATE TABLE `t_user_change_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL COMMENT '被修改用户ID',
  `before_data` json NOT NULL COMMENT '变更前快照 {id_type,id_number,id_valid_until}',
  `after_data` json NOT NULL COMMENT '变更后快照',
  `admin_id` int unsigned NOT NULL COMMENT '操作管理员ID',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_admin_id` (`admin_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户证件信息修改记录';
