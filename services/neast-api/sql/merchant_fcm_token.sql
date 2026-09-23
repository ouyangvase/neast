-- 商家 FCM Token（独立表，不在 t_merchant 存 fcm_token）

CREATE TABLE `t_merchant_fcm_token` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `merchant_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商家ID',
  `token` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'FCM Token',
  `platform` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '平台 ios/android',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_token` (`token`),
  KEY `idx_merchant_id` (`merchant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商家FCM Token';
