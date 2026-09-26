-- 租约起止月份。lease_months 改为 NEAST 交租期数，expire_date 改为租约结束月最后一天。

ALTER TABLE `t_rent`
  ADD COLUMN `agreement_start` date DEFAULT NULL COMMENT '租约开始月份(存当月1号)' AFTER `paid_at`,
  ADD COLUMN `agreement_end` date DEFAULT NULL COMMENT '租约结束月份(存当月1号)' AFTER `agreement_start`;

UPDATE `t_rent`
SET
  `agreement_start` = `first_pay_month`,
  `agreement_end` = DATE_ADD(`first_pay_month`, INTERVAL (`lease_months` - 1) MONTH),
  `expire_date` = LAST_DAY(DATE_ADD(`first_pay_month`, INTERVAL (`lease_months` - 1) MONTH))
WHERE `agreement_start` IS NULL
  AND `first_pay_month` IS NOT NULL
  AND `lease_months` >= 1;
