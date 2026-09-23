-- 佣金配置已迁移至 t_merchant.points_per_rm

ALTER TABLE `t_points_setting`
  DROP COLUMN `points_per_rm_commission`;
