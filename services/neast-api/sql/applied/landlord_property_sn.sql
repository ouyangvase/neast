-- 房东物业表：新增唯一 sn

ALTER TABLE `t_landlord_property`
  ADD COLUMN `sn` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '唯一编号' AFTER `landlord_id`;

-- 为已有记录生成 sn（LP + 16 位大写 hex）
UPDATE `t_landlord_property`
SET `sn` = CONCAT('LP', UPPER(SUBSTRING(MD5(CONCAT('property:', id, ':', UNIX_TIMESTAMP())), 1, 16)))
WHERE `sn` = '' OR `sn` IS NULL;

ALTER TABLE `t_landlord_property`
  ADD UNIQUE KEY `uk_sn` (`sn`);
