-- 商家账单

CREATE TABLE `t_merchant_bill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `merchant_id` int unsigned NOT NULL COMMENT '商家ID',
  `bill_month` char(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账单年月 YYYY-MM',
  `amount` decimal(12, 2) NOT NULL DEFAULT '0.00' COMMENT '账单金额',
  `points` int unsigned NOT NULL DEFAULT '0' COMMENT '积分',
  `is_paid` tinyint NOT NULL DEFAULT '0' COMMENT '是否支付 0否 1是',
  `payment_date` date DEFAULT NULL COMMENT '支付日期',
  `payment_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付方式 wallet钱包 online网上支付',
  `order_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Fiuu 订单号',
  `txn_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Fiuu 交易号',
  `channel` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Fiuu 支付渠道',
  `pay_amount` decimal(12, 2) DEFAULT NULL COMMENT '含手续费实付金额',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_merchant_bill_month` (`merchant_id`, `bill_month`),
  UNIQUE KEY `uk_order_id` (`order_id`),
  KEY `idx_merchant_id` (`merchant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商家账单表';
