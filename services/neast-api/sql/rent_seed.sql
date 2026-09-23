-- 租金测试数据（user_id 固定为 1，paid_at 为每月交租日）

SET @landlord_id = (
  SELECT `id`
  FROM `t_landlord`
  WHERE `deleted_at` IS NULL
  ORDER BY `id` ASC
  LIMIT 1
);

INSERT INTO `t_rent` (
  `user_id`,
  `amount`,
  `file`,
  `paid_at`,
  `expire_date`,
  `property_id`,
  `landlord_id`,
  `status`,
  `landlord_bank`,
  `landlord_bank_account`,
  `landlord_account_name`,
  `created_at`,
  `updated_at`
) VALUES
(1, 2500.00, '/uploads/rent/voucher-20260301.jpg', 1, '2026-06-30', NULL, NULL, 0, '', '', '', NOW(), NOW()),
(1, 1800.50, '/uploads/rent/voucher-20260215.jpg', 15, '2026-12-31', NULL, @landlord_id, 1, 'Maybank', '512345678901', 'Ahmad Property', NOW(), NOW()),
(1, 3200.00, '/uploads/rent/voucher-20260120.jpg', 20, '2026-03-31', NULL, NULL, 2, '', '', '', NOW(), NOW());
