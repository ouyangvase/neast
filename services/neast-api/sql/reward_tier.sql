-- 奖励等级表（固定 5 档）

CREATE TABLE IF NOT EXISTS `t_reward_tier` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '等级名称',
  `min_points` int NOT NULL DEFAULT '0' COMMENT '最低积分',
  `max_points` int NOT NULL DEFAULT '0' COMMENT '最高积分',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='奖励等级';

INSERT INTO `t_reward_tier` (`id`, `name`, `min_points`, `max_points`, `created_at`, `updated_at`)
VALUES
  (1, 'Bronze', 0, 999, NOW(), NOW()),
  (2, 'Silver', 1000, 2999, NOW(), NOW()),
  (3, 'Gold', 3000, 7499, NOW(), NOW()),
  (4, 'Platinum', 7500, 9999, NOW(), NOW()),
  (5, 'Diamond', 10000, 9999999, NOW(), NOW())
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `min_points` = VALUES(`min_points`),
  `max_points` = VALUES(`max_points`),
  `updated_at` = NOW();
