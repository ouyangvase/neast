-- 用户兑换优惠券记录（含兑换时快照）

CREATE TABLE `t_user_coupon` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL COMMENT '用户ID',
  `coupon_id` int unsigned NOT NULL COMMENT '优惠券ID',
  `sn` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '券码，6位大写字母数字',
  `redeem_token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '核销 token，QR 编码用',
  `used_points` int unsigned NOT NULL DEFAULT '0' COMMENT '兑换使用积分',
  `expire_at` datetime NOT NULL COMMENT '过期时间',
  `discount_amount` decimal(10, 2) unsigned NOT NULL DEFAULT '0.00' COMMENT '优惠金额(兑换快照)',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '优惠券名称(兑换快照)',
  `usage_condition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '使用条件(兑换快照)',
  `merchant_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '可用商家ID快照，逗号分隔',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态 0未使用 1已使用',
  `redeemed_merchant_id` int unsigned NOT NULL DEFAULT '0' COMMENT '核销商家ID',
  `redeemed_at` datetime DEFAULT NULL COMMENT '商家核销时间',
  `created_at` datetime DEFAULT NULL COMMENT '兑换时间',
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_coupon_id` (`coupon_id`),
  KEY `idx_user_status` (`user_id`, `status`),
  KEY `idx_expire_at` (`expire_at`),
  UNIQUE KEY `uk_sn` (`sn`),
  UNIQUE KEY `uk_redeem_token` (`redeem_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户兑换优惠券记录表';
