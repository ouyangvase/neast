-- 房东表：验证码登录改造（删除 account/password，新增 first_name/last_name）

ALTER TABLE `t_landlord`
  ADD COLUMN `first_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '名' AFTER `name`,
  ADD COLUMN `last_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '姓' AFTER `first_name`;

-- 将现有 name 写入 first_name
UPDATE `t_landlord` SET `first_name` = TRIM(`name`) WHERE `first_name` = '';

-- phone 为空时从 account 迁移
UPDATE `t_landlord` SET `phone` = TRIM(`account`) WHERE `phone` IS NULL OR TRIM(`phone`) = '';

-- 同步 name
UPDATE `t_landlord` SET `name` = TRIM(CONCAT(`first_name`, ' ', `last_name`));

ALTER TABLE `t_landlord`
  DROP INDEX `uk_account`,
  DROP COLUMN `account`,
  DROP COLUMN `password`,
  MODIFY COLUMN `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机号（登录账号）';
