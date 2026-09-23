-- 房东银行资料字段

ALTER TABLE `t_landlord`
  ADD `bank_name` varchar(128) NOT NULL DEFAULT '' COMMENT '银行名称' AFTER `email`,
  ADD `bank_account` varchar(64) NOT NULL DEFAULT '' COMMENT '银行账号' AFTER `bank_name`,
  ADD `account_holder_name` varchar(128) NOT NULL DEFAULT '' COMMENT '账户持有人姓名' AFTER `bank_account`,
  ADD `bank_header_photo` varchar(512) NOT NULL DEFAULT '' COMMENT '银行抬头照路径' AFTER `account_holder_name`;
