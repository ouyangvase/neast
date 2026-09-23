-- 房东 FCM Token（独立表，不在 t_landlord 存 fcm_token）

CREATE TABLE `t_landlord_fcm_token` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `landlord_id` int unsigned NOT NULL DEFAULT '0' COMMENT '房东ID',
  `token` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'FCM Token',
  `platform` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '平台 ios/android',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_token` (`token`),
  KEY `idx_landlord_id` (`landlord_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='房东FCM Token';
