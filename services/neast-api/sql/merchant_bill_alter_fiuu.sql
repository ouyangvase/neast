-- Fiuu 支付：商家账单表扩展字段

ALTER TABLE `t_merchant_bill`
  ADD COLUMN `order_id` varchar(64) NOT NULL DEFAULT '' COMMENT 'Fiuu 订单号' AFTER `payment_method`,
  ADD COLUMN `txn_id` varchar(64) NOT NULL DEFAULT '' COMMENT 'Fiuu 交易号' AFTER `order_id`,
  ADD COLUMN `channel` varchar(32) NOT NULL DEFAULT '' COMMENT 'Fiuu 支付渠道' AFTER `txn_id`,
  ADD COLUMN `pay_amount` decimal(12, 2) DEFAULT NULL COMMENT '含手续费实付金额' AFTER `channel`;

ALTER TABLE `t_merchant_bill`
  ADD UNIQUE KEY `uk_order_id` (`order_id`);