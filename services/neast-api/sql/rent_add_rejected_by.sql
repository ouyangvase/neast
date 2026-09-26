-- 驳回来源：区分管理员驳回与房东拒绝绑定

ALTER TABLE `t_rent`
  ADD `rejected_by` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '驳回来源 admin|owner' AFTER `status`;
