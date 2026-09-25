-- 优惠券

CREATE TABLE `t_coupon` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `required_points` int unsigned NOT NULL DEFAULT '0' COMMENT '所需积分',
  `valid_days` int unsigned NOT NULL DEFAULT '0' COMMENT '有效期(天)',
  `discount_amount` decimal(10, 2) unsigned NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `usage_condition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '使用条件',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态 0停用 1启用',
  `redeem_limit` int unsigned DEFAULT NULL COMMENT '兑换次数 NULL表示不限制',
  `category_id` int unsigned NOT NULL DEFAULT '0' COMMENT '优惠券分类ID',
  `image` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '列表展示图片',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='优惠券表';

CREATE TABLE `t_coupon_merchant` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `merchant_id` int unsigned NOT NULL COMMENT '商家ID',
  `coupon_id` int unsigned NOT NULL COMMENT '优惠券ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_merchant_coupon` (`merchant_id`, `coupon_id`),
  KEY `idx_coupon_id` (`coupon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='优惠券关联商家表';
