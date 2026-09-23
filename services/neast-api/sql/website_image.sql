-- 官网图片

CREATE TABLE `t_website_image` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `image` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片相对路径',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='官网图片';
