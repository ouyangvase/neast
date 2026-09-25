ALTER TABLE `t_merchant`
  ADD COLUMN `category_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商家分类ID' AFTER `is_recommended`;
