-- 还款计划作废状态

ALTER TABLE `t_rent_history`
  MODIFY `status` tinyint NOT NULL DEFAULT 0 COMMENT '0待还款 1已还款 2平台已结算 3已作废';
