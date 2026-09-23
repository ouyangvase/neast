-- t_rent_history 增加付款方式

ALTER TABLE `t_rent_history`
  ADD COLUMN `payment_method` varchar(32) NOT NULL DEFAULT '' COMMENT '付款方式' AFTER `user_paid_at`;
