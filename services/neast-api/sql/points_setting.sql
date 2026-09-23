-- 积分设置（单行）

CREATE TABLE `t_points_setting` (
  `id` int unsigned NOT NULL DEFAULT '1' COMMENT '固定为1',
  `rent_points_multiplier` decimal(6, 1) unsigned NOT NULL DEFAULT '1.0' COMMENT '还租金积分金额倍数',
  `spend_points_multiplier` decimal(6, 1) unsigned NOT NULL DEFAULT '1.0' COMMENT '消费可获得积分金额倍数',
  `yuan_to_points` int unsigned NOT NULL DEFAULT '1' COMMENT '1 RM兑换积分数',
  `inviter_reward_points` int unsigned NOT NULL DEFAULT '0' COMMENT '邀请人奖励积分',
  `invitee_reward_points` int unsigned NOT NULL DEFAULT '0' COMMENT '被邀请人奖励积分',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='积分设置表';

INSERT INTO `t_points_setting` (
  `id`,
  `rent_points_multiplier`,
  `spend_points_multiplier`,
  `yuan_to_points`,
  `inviter_reward_points`,
  `invitee_reward_points`
) VALUES (1, 1.0, 1.0, 100, 0, 0);
