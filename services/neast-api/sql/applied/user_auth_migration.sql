-- 用户表：仅手机号登录，新增 email 字段，删除 account_type

ALTER TABLE `t_user`
  ADD COLUMN `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邮箱（可选）' AFTER `account`;

-- 历史邮箱注册用户：将 account 迁入 email，便于后台查看
UPDATE `t_user`
  SET `email` = `account`
  WHERE `account_type` = 'email' AND `email` = '';

ALTER TABLE `t_user` DROP COLUMN `account_type`;
