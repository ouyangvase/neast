-- t_user 增加软删除字段

ALTER TABLE `t_user` ADD COLUMN `deleted_at` datetime DEFAULT NULL COMMENT '软删除时间';
