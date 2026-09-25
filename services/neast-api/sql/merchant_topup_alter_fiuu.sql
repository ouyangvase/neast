-- Fiuu 支付：商家充值表扩展字段

ALTER TABLE `t_merchant_topup`
  ADD COLUMN `order_id` varchar(64) NOT NULL DEFAULT '' COMMENT 'Fiuu 订单号' AFTER `payment_method`,
  ADD COLUMN `status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '状态 0待支付 1成功 2失败' AFTER `order_id`,
  ADD COLUMN `txn_id` varchar(64) NOT NULL DEFAULT '' COMMENT 'Fiuu 交易号' AFTER `status`,
  ADD COLUMN `channel` varchar(32) NOT NULL DEFAULT '' COMMENT 'Fiuu 支付渠道' AFTER `txn_id`,
  MODIFY COLUMN `paid_at` datetime DEFAULT NULL COMMENT '支付时间';

ALTER TABLE `t_merchant_topup`
  ADD UNIQUE KEY `uk_order_id` (`order_id`);
