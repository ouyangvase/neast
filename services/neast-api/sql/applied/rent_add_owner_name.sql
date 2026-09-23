ALTER TABLE `t_rent`
  ADD COLUMN `owner_name` varchar(128) NOT NULL DEFAULT '' COMMENT '房东名称(未绑物业时用户填写)' AFTER `landlord_id`;
