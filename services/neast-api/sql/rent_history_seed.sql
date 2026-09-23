-- 房租还款结算测试数据（user_id=1，需先有 t_rent 记录）

SET @rent_id = (SELECT `id` FROM `t_rent` WHERE `deleted_at` IS NULL ORDER BY `id` ASC LIMIT 1);
SET @admin_id = (SELECT `id` FROM `t_admin` ORDER BY `id` ASC LIMIT 1);
SET @amount = (SELECT `amount` FROM `t_rent` WHERE `id` = @rent_id LIMIT 1);

INSERT INTO `t_rent_history` (
  `rent_id`, `user_id`, `amount`, `last_paid_date`, `user_paid_at`, `platform_settled_at`,
  `settled_by`, `receipt`, `status`, `is_confirm`, `confirm_at`, `created_at`, `updated_at`
)
SELECT @rent_id, 1, IFNULL(@amount, 0), '2025-01-01', NULL, NULL, NULL, '', 0, 0, NULL, NOW(), NOW()
WHERE @rent_id IS NOT NULL
UNION ALL
SELECT @rent_id, 1, IFNULL(@amount, 0), '2026-04-01', '2026-04-02 10:00:00', NULL, NULL, '', 1, 0, NULL, NOW(), NOW()
WHERE @rent_id IS NOT NULL
UNION ALL
SELECT @rent_id, 1, IFNULL(@amount, 0), '2025-12-01', '2025-12-02 15:30:00', '2025-12-03 09:00:00', @admin_id, '/uploads/rent/receipt-settled-001.jpg', 2, 1, '2025-12-02 16:00:00', NOW(), NOW()
WHERE @rent_id IS NOT NULL;
