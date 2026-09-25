-- 若已执行旧版 user_add_location（含 location POINT / SPATIAL INDEX），用本脚本清理后按新版重建索引

-- 先删空间索引（若存在）
ALTER TABLE `t_user` DROP INDEX `idx_location`;

-- 再删 POINT 列（若存在）
ALTER TABLE `t_user` DROP COLUMN `location`;

-- 补普通索引（若 idx_last_lat_lng 尚未创建）
ALTER TABLE `t_user` ADD KEY `idx_last_lat_lng` (`last_latitude`, `last_longitude`);
