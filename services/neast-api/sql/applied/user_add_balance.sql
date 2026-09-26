-- t_user 钱包余额（模型与充值入账已使用该列）

ALTER TABLE `t_user` ADD COLUMN `balance` decimal(12, 2) NOT NULL DEFAULT '0.00' COMMENT '钱包余额' AFTER `tent_score`;
