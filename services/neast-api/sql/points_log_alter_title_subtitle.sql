-- t_points_log：remark 改为 title + subtitle

ALTER TABLE `t_points_log`
  DROP COLUMN `remark`,
  ADD COLUMN `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题' AFTER `points`,
  ADD COLUMN `subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '副标题' AFTER `title`;
