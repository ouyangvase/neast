ALTER TABLE `t_coupon`
  ADD COLUMN `image` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '列表展示图片' AFTER `category_id`;
