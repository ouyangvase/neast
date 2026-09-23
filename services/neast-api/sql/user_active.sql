-- 用户日活跃记录（每个用户每天最多一条）

CREATE TABLE `t_user_active` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `active_date` date NOT NULL COMMENT '活跃日期',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_active_date` (`user_id`, `active_date`),
  KEY `idx_active_date` (`active_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户日活跃';
