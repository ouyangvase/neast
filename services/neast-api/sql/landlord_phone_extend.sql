-- 扩展 phone 字段长度，以容纳删除账号时的 _del{timestamp} 后缀

ALTER TABLE `t_landlord`
  MODIFY COLUMN `phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机号（登录账号）';
