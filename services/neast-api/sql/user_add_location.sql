-- 用户最后上报位置（兼容 MySQL 5.7：不用 POINT / SPATIAL INDEX）

ALTER TABLE `t_user`
  ADD COLUMN `last_latitude` decimal(10, 7) DEFAULT NULL COMMENT '最后上报纬度' AFTER `last_active_at`,
  ADD COLUMN `last_longitude` decimal(10, 7) DEFAULT NULL COMMENT '最后上报经度' AFTER `last_latitude`,
  ADD COLUMN `last_location_at` datetime DEFAULT NULL COMMENT '最后位置上报时间' AFTER `last_longitude`,
  ADD KEY `idx_last_location_at` (`last_location_at`),
  ADD KEY `idx_last_lat_lng` (`last_latitude`, `last_longitude`);
