-- 租金记录：租期月份数

ALTER TABLE `t_rent`
  ADD COLUMN `lease_months` int unsigned NOT NULL DEFAULT '0' COMMENT '租期月份数' AFTER `first_pay_month`;
