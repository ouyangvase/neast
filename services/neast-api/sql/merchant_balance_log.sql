-- 商家余额流水

CREATE TABLE `t_merchant_balance_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `merchant_id` int unsigned NOT NULL COMMENT '商家ID',
  `amount` decimal(12, 2) NOT NULL DEFAULT '0.00' COMMENT '变动金额(可为负数)',
  `balance_after` decimal(12, 2) NOT NULL DEFAULT '0.00' COMMENT '交易后余额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_merchant_id` (`merchant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商家余额流水表';
