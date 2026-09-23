-- 用户表：invitation_code 唯一约束

-- 为空邀请码回填 6 位大写字母+数字（每行 UUID 不同）
UPDATE `t_user`
SET `invitation_code` = UPPER(SUBSTRING(REPLACE(UUID(), '-', ''), 1, 6))
WHERE TRIM(`invitation_code`) = '';

-- 若存在重复邀请码，为重复记录重新生成（保留最小 id）
UPDATE `t_user` AS `t`
INNER JOIN (
  SELECT `invitation_code`, MIN(`id`) AS `keep_id`
  FROM `t_user`
  WHERE TRIM(`invitation_code`) <> ''
  GROUP BY `invitation_code`
  HAVING COUNT(*) > 1
) AS `dup` ON `t`.`invitation_code` = `dup`.`invitation_code` AND `t`.`id` <> `dup`.`keep_id`
SET `t`.`invitation_code` = UPPER(SUBSTRING(REPLACE(UUID(), '-', ''), 1, 6));

ALTER TABLE `t_user`
  ADD UNIQUE KEY `uk_invitation_code` (`invitation_code`);
