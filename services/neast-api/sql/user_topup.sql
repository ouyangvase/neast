-- 用户充值记录

CREATE TABLE `t_user_topup` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL COMMENT '用户ID',
  `amount` decimal(12, 2) NOT NULL DEFAULT '0.00' COMMENT '充值金额',
  `payment_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付方式 fpx/tng/grab/visa',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Fiuu 订单号',
  `status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '状态 0待支付 1成功 2失败',
  `txn_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Fiuu 交易号',
  `channel` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Fiuu 支付渠道',
  `paid_at` datetime DEFAULT NULL COMMENT '支付时间',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_id` (`order_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_paid_at` (`paid_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户充值记录';
