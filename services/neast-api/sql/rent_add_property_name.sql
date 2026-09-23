ALTER TABLE `t_rent`
  ADD COLUMN `property_name` varchar(128) NOT NULL DEFAULT '' COMMENT '房产名称(未绑定时用户填写)' AFTER `property_id`;
