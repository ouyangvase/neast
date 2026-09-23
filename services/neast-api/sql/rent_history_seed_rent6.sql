-- t_rent_history 测试数据：rent_id=6, user_id=7
-- 覆盖 Property Journey 三种状态：按时 / 逾期 / 未到支付时间
-- 基准日期：2026-07-16

DELETE FROM `t_rent_history` WHERE `rent_id` = 6;

INSERT INTO `t_rent_history` (
  `rent_id`, `user_id`, `amount`, `last_paid_date`, `user_paid_at`, `payment_method`,
  `platform_settled_at`, `settled_by`, `receipt`, `status`, `is_confirm`,
  `confirm_at`, `created_at`, `updated_at`
) VALUES
-- 按时支付（On Time）：到期日当日或之前付款
(6, 7, 2000.00, '2026-04-01', '2026-04-01 10:30:00', 'Wallet', '2026-04-02 09:00:00', 1, '/uploads/rent/receipt-rent6-202604.jpg', 2, 1, '2026-04-02 10:00:00', NOW(), NOW()),
(6, 7, 2000.00, '2026-05-01', '2026-05-01 14:20:00', 'Wallet', NULL, NULL, '', 1, 0, NULL, NOW(), NOW()),
(6, 7, 2000.00, '2026-06-01', '2026-06-01 09:15:00', 'Wallet', NULL, NULL, '', 1, 0, NULL, NOW(), NOW()),

-- 逾期（Late）：待还款且已过到期日，或逾期后补交
(6, 7, 2000.00, '2026-02-01', NULL, '', NULL, NULL, '', 0, 0, NULL, NOW(), NOW()),
(6, 7, 2000.00, '2026-03-01', NULL, '', NULL, NULL, '', 0, 0, NULL, NOW(), NOW()),
(6, 7, 2000.00, '2026-07-01', NULL, '', NULL, NULL, '', 0, 0, NULL, NOW(), NOW()),
(6, 7, 2000.00, '2026-01-01', '2026-01-08 16:45:00', 'Wallet', NULL, NULL, '', 1, 0, NULL, NOW(), NOW()),

-- 未到支付时间（Upcoming）：待还款且到期日在今天或之后
(6, 7, 2000.00, '2026-08-01', NULL, '', NULL, NULL, '', 0, 0, NULL, NOW(), NOW()),
(6, 7, 2000.00, '2026-09-01', NULL, '', NULL, NULL, '', 0, 0, NULL, NOW(), NOW()),
(6, 7, 2000.00, '2026-10-01', NULL, '', NULL, NULL, '', 0, 0, NULL, NOW(), NOW()),
(6, 7, 2000.00, '2026-11-01', NULL, '', NULL, NULL, '', 0, 0, NULL, NOW(), NOW()),
(6, 7, 2000.00, '2026-12-01', NULL, '', NULL, NULL, '', 0, 0, NULL, NOW(), NOW()),
(6, 7, 2000.00, '2027-01-01', NULL, '', NULL, NULL, '', 0, 0, NULL, NOW(), NOW());
