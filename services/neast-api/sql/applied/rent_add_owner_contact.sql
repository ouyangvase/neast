ALTER TABLE `t_rent`
  ADD COLUMN `owner_email` varchar(128) NOT NULL DEFAULT '' COMMENT '未绑定房东时租客填写的邮箱' AFTER `owner_name`,
  ADD COLUMN `owner_phone` varchar(32) NOT NULL DEFAULT '' COMMENT '未绑定房东时租客填写的手机号' AFTER `owner_email`;
