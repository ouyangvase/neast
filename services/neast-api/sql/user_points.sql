-- 用户积分明细（每笔积分独立过期时间）

CREATE TABLE IF NOT EXISTS `t_user_points` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL COMMENT '用户ID',
  `points` int NOT NULL DEFAULT '0' COMMENT '积分数量',
  `expired_date` date NOT NULL COMMENT '过期日期（含当日仍有效）',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_expired` (`user_id`, `expired_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户积分明细';
