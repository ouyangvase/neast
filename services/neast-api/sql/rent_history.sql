-- 房租还款结算记录

CREATE TABLE `t_rent_history` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `rent_id` int unsigned NOT NULL COMMENT '租金ID',
  `user_id` int unsigned NOT NULL COMMENT '用户ID',
  `amount` decimal(12, 2) NOT NULL DEFAULT '0.00' COMMENT '还款金额',
  `last_paid_date` date NOT NULL COMMENT '最后交租时间',
  `user_paid_at` datetime DEFAULT NULL COMMENT '用户付款时间',
  `payment_method` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '付款方式',
  `platform_settled_at` datetime DEFAULT NULL COMMENT '平台结算时间',
  `settled_by` int unsigned DEFAULT NULL COMMENT '结算操作人',
  `receipt` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '结算收据URL',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态 0待还款 1已还款 2平台已结算',
  `is_confirm` tinyint NOT NULL DEFAULT '0' COMMENT '房东是否确认 0否 1是',
  `confirm_at` datetime DEFAULT NULL COMMENT '房东确认时间',
  `inviter_user_id` int unsigned DEFAULT NULL COMMENT '邀请奖励已发放给的邀请人用户ID，NULL表示未发放',
  `inviter_reward_points` int unsigned NOT NULL DEFAULT '0' COMMENT '已发放给邀请人的积分，0表示未发放',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_rent_id` (`rent_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_last_paid_date` (`last_paid_date`),
  KEY `idx_settled_by` (`settled_by`),
  KEY `idx_inviter_user_id` (`inviter_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='房租还款结算表';
