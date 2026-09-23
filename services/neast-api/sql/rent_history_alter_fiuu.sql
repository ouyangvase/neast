-- Fiuu 支付：房租还款表扩展字段

ALTER TABLE `t_rent_history`
  ADD COLUMN `order_id` varchar(64) DEFAULT NULL COMMENT 'Fiuu 订单号' AFTER `payment_method`,
  ADD COLUMN `txn_id` varchar(64) NOT NULL DEFAULT '' COMMENT 'Fiuu 交易号' AFTER `order_id`,
  ADD COLUMN `channel` varchar(32) NOT NULL DEFAULT '' COMMENT 'Fiuu 支付渠道' AFTER `txn_id`;

ALTER TABLE `t_rent_history`
  ADD UNIQUE KEY `uk_order_id` (`order_id`);
