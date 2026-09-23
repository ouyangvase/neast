-- 租金记录 status 注释：新增 3待绑定

ALTER TABLE `t_rent`
  MODIFY COLUMN `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态 0待审核 1审核通过 2驳回 3待绑定';
