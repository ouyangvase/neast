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
  `first_pay_month`,
  `lease_months`,
  `expire_date`,
  `property_id`,
  `property_name`,
  `landlord_id`,
  `owner_name`,
  `status`,
  `link_status`,
  `landlord_bank`,
  `landlord_bank_account`,
  `landlord_account_name`,
  `created_at`,
  `updated_at`
) VALUES
(1, 1800.50, '/uploads/rent/voucher-20260215.jpg', 15, '2026-01-01', 12, '2026-12-31', NULL, 'Smoke Villa', @landlord_id, '', 1, 'none', 'Maybank', '512345678901', 'Ahmad Property', NOW(), NOW());
