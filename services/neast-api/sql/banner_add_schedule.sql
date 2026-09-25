-- Schedule window for home campaign banners. Null bound means open on that side.

ALTER TABLE `t_banner`
  ADD COLUMN `starts_at` datetime DEFAULT NULL COMMENT '展示开始时间，空表示不限' AFTER `status`,
  ADD COLUMN `ends_at` datetime DEFAULT NULL COMMENT '展示结束时间，空表示不限' AFTER `starts_at`;
