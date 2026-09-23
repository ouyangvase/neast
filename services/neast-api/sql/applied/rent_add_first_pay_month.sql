-- 租金记录：首次交租月份

ALTER TABLE `t_rent`
  ADD COLUMN `first_pay_month` date DEFAULT NULL COMMENT '首次交租月份(存当月1号)' AFTER `paid_at`;
