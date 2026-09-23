-- 商家余额流水测试数据（为第一个未删除商家插入）

SET @merchant_id = (
  SELECT `id`
  FROM `t_merchant`
  WHERE `deleted_at` IS NULL
  ORDER BY `id`
  LIMIT 1
);

INSERT INTO `t_merchant_balance_log` (
  `merchant_id`,
  `amount`,
  `balance_after`,
  `remark`,
  `created_at`,
  `updated_at`
)
SELECT
  @merchant_id,
  `amount`,
  `balance_after`,
  `remark`,
  `created_at`,
  `updated_at`
FROM (
  SELECT 1000.00 AS `amount`, 1000.00 AS `balance_after`, 'Wallet top-up' AS `remark`, NOW() - INTERVAL 10 DAY AS `created_at`, NOW() - INTERVAL 10 DAY AS `updated_at`
  UNION ALL
  SELECT 500.00, 1500.00, 'Offline recharge', NOW() - INTERVAL 8 DAY, NOW() - INTERVAL 8 DAY
  UNION ALL
  SELECT -200.00, 1300.00, 'Points campaign payment', NOW() - INTERVAL 5 DAY, NOW() - INTERVAL 5 DAY
  UNION ALL
  SELECT -150.00, 1150.00, 'Service fee', NOW() - INTERVAL 3 DAY, NOW() - INTERVAL 3 DAY
  UNION ALL
  SELECT 300.00, 1450.00, 'Manual adjustment', NOW() - INTERVAL 1 DAY, NOW() - INTERVAL 1 DAY
) AS `seed`
WHERE @merchant_id IS NOT NULL;

UPDATE `t_merchant`
SET `balance` = 1450.00
WHERE `id` = @merchant_id;
