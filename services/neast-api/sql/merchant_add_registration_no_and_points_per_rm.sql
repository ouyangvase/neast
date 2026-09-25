-- 商家表新增手填注册号与 per-merchant 佣金配置

ALTER TABLE `t_merchant`
  ADD COLUMN `registration_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '注册号' AFTER `registration_number`,
  ADD COLUMN `points_per_rm` int unsigned NOT NULL DEFAULT '100' COMMENT '赠送多少积分需支付1RM佣金' AFTER `registration_no`;
