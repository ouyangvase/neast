-- 三端消息表

CREATE TABLE `t_message_user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `is_read` tinyint NOT NULL DEFAULT '0' COMMENT '0未读 1已读',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_user_read` (`user_id`, `is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户端消息';

CREATE TABLE `t_message_landlord` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `landlord_id` int unsigned NOT NULL DEFAULT '0' COMMENT '房东ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `is_read` tinyint NOT NULL DEFAULT '0' COMMENT '0未读 1已读',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_landlord_id` (`landlord_id`),
  KEY `idx_landlord_read` (`landlord_id`, `is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='房东端消息';

CREATE TABLE `t_message_merchant` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `merchant_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商家ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `is_read` tinyint NOT NULL DEFAULT '0' COMMENT '0未读 1已读',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_merchant_id` (`merchant_id`),
  KEY `idx_merchant_read` (`merchant_id`, `is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商家端消息';
