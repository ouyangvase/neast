-- 首页 Banner 轮播

CREATE TABLE `t_banner` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `image` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片路径',
  `link` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '跳转链接(可选)',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序，越大越靠前',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态 0停用 1启用',
  `starts_at` datetime DEFAULT NULL COMMENT '展示开始时间，空表示不限',
  `ends_at` datetime DEFAULT NULL COMMENT '展示结束时间，空表示不限',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status_sort` (`status`, `sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='首页Banner';
