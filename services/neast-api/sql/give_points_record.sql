-- 积分发放记录

CREATE TABLE `t_give_points_record` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL COMMENT '用户ID',
  `amount` decimal(10, 2) unsigned NOT NULL DEFAULT '0.00' COMMENT '消费金额',
  `points` int unsigned NOT NULL DEFAULT '0' COMMENT '发放积分',
  `merchant_id` int unsigned NOT NULL COMMENT '商家ID',
  `notes` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `receipt_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '票据编号',
  `receipt_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '票据文件',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_merchant_id` (`merchant_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='积分发放记录表';
