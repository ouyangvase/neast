-- 租约终止：新增 status=4 及审计字段

ALTER TABLE `t_rent`
  MODIFY `status` tinyint NOT NULL DEFAULT 0 COMMENT '0待审核 1审核通过 2驳回 3待绑定 4已终止',
  ADD `terminated_at` datetime NULL COMMENT '终止时间' AFTER `status`,
  ADD `terminated_by` int unsigned NULL COMMENT '终止操作人(admin id)' AFTER `terminated_at`,
  ADD `terminate_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '终止原因' AFTER `terminated_by`;
