-- 商家账单测试数据（为第一个未删除商家插入）

SET @merchant_id = (
  SELECT `id`
  FROM `t_merchant`
  WHERE `deleted_at` IS NULL
  ORDER BY `id`
  LIMIT 1
);

INSERT INTO `t_merchant_bill` (
  `merchant_id`,
  `bill_month`,
  `amount`,
  `points`,
  `is_paid`,
  `payment_date`,
  `payment_method`,
  `created_at`,
  `updated_at`
)
SELECT
  @merchant_id,
  `bill_month`,
  `amount`,
  `points`,
  `is_paid`,
  `payment_date`,
  `payment_method`,
  `created_at`,
  `updated_at`
FROM (
  SELECT '2026-03' AS `bill_month`, 850.00 AS `amount`, 650 AS `points`, 0 AS `is_paid`, NULL AS `payment_date`, '' AS `payment_method`, NOW() AS `created_at`, NOW() AS `updated_at`
  UNION ALL
  SELECT '2026-02', 620.50, 480, 1, '2026-03-01', 'wallet', NOW() - INTERVAL 20 DAY, NOW() - INTERVAL 20 DAY
  UNION ALL
  SELECT '2026-01', 980.00, 720, 1, '2026-02-01', 'online', NOW() - INTERVAL 50 DAY, NOW() - INTERVAL 50 DAY
  UNION ALL
  SELECT '2025-12', 735.25, 540, 1, '2026-01-01', 'wallet', NOW() - INTERVAL 80 DAY, NOW() - INTERVAL 80 DAY
) AS `seed`
WHERE @merchant_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM `t_merchant_bill` LIMIT 1);
