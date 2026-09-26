-- Tenancy state fixtures for the users in user_seed.sql. Idempotent.
-- Phones are +60 plus the local number. OTP is 123456.

INSERT INTO `t_rent` (
  `user_id`, `amount`, `file`, `paid_at`, `first_pay_month`, `lease_months`, `expire_date`,
  `property_id`, `property_name`, `landlord_id`, `owner_name`, `status`, `rejected_by`,
  `landlord_bank`, `landlord_bank_account`, `landlord_account_name`, `created_at`, `updated_at`
)
SELECT u.id, 1100.00, '/uploads/rent/local-test-agreement.jpg', 15, '2026-10-01', 12, '2027-09-26',
  NULL, 'Pending Review House', NULL, 'Lim Wei', 0, '',
  'Maybank', '111122223333', 'Lim Wei', NOW(), NOW()
FROM `t_user` u
WHERE u.account = '60222222222'
  AND NOT EXISTS (SELECT 1 FROM `t_rent` r WHERE r.user_id = u.id AND r.deleted_at IS NULL);

INSERT INTO `t_rent` (
  `user_id`, `amount`, `file`, `paid_at`, `first_pay_month`, `lease_months`, `expire_date`,
  `property_id`, `property_name`, `landlord_id`, `owner_name`, `status`, `rejected_by`,
  `landlord_bank`, `landlord_bank_account`, `landlord_account_name`, `created_at`, `updated_at`
)
SELECT u.id, 1300.00, '/uploads/rent/local-test-agreement.jpg', 15, '2026-10-01', 12, '2027-09-26',
  2, 'Kiulap Apartment', 1, 'Smoke Test', 3, '',
  'Maybank', '1234567890', 'Smoke Test', NOW(), NOW()
FROM `t_user` u
WHERE u.account = '60333333333'
  AND NOT EXISTS (SELECT 1 FROM `t_rent` r WHERE r.user_id = u.id AND r.deleted_at IS NULL);

INSERT INTO `t_rent` (
  `user_id`, `amount`, `file`, `paid_at`, `first_pay_month`, `lease_months`, `expire_date`,
  `property_id`, `property_name`, `landlord_id`, `owner_name`, `status`, `rejected_by`,
  `landlord_bank`, `landlord_bank_account`, `landlord_account_name`, `created_at`, `updated_at`
)
SELECT u.id, 1400.00, '/uploads/rent/local-test-agreement.jpg', 15, '2026-10-01', 12, '2027-09-26',
  NULL, 'Admin Reject House', NULL, 'Ahmad', 2, 'admin',
  'Maybank', '222233334444', 'Ahmad', NOW(), NOW()
FROM `t_user` u
WHERE u.account = '60444444444'
  AND NOT EXISTS (SELECT 1 FROM `t_rent` r WHERE r.user_id = u.id AND r.deleted_at IS NULL);

INSERT INTO `t_rent` (
  `user_id`, `amount`, `file`, `paid_at`, `first_pay_month`, `lease_months`, `expire_date`,
  `property_id`, `property_name`, `landlord_id`, `owner_name`, `status`, `rejected_by`,
  `landlord_bank`, `landlord_bank_account`, `landlord_account_name`, `created_at`, `updated_at`
)
SELECT u.id, 1450.00, '/uploads/rent/local-test-agreement.jpg', 15, '2026-10-01', 12, '2027-09-26',
  3, 'Gadong Terrace', 1, 'Smoke Test', 2, 'owner',
  'Maybank', '1234567890', 'Smoke Test', NOW(), NOW()
FROM `t_user` u
WHERE u.account = '60555555555'
  AND NOT EXISTS (SELECT 1 FROM `t_rent` r WHERE r.user_id = u.id AND r.deleted_at IS NULL);

-- Due today (26 Sep 2026). Wallet covers one month.
INSERT INTO `t_rent` (
  `user_id`, `amount`, `file`, `paid_at`, `first_pay_month`, `lease_months`, `expire_date`,
  `property_id`, `property_name`, `landlord_id`, `owner_name`, `status`, `rejected_by`,
  `landlord_bank`, `landlord_bank_account`, `landlord_account_name`, `created_at`, `updated_at`
)
SELECT u.id, 1500.00, '/uploads/rent/local-test-agreement.jpg', 26, '2026-09-01', 12, '2027-09-01',
  NULL, 'Due Today Home', NULL, 'Siti', 1, '',
  'Maybank', '333344445555', 'Siti', '2026-09-01 10:00:00', NOW()
FROM `t_user` u
WHERE u.account = '60666666666'
  AND NOT EXISTS (SELECT 1 FROM `t_rent` r WHERE r.user_id = u.id AND r.deleted_at IS NULL);

INSERT INTO `t_rent_history` (
  `rent_id`, `user_id`, `amount`, `last_paid_date`, `payment_method`, `txn_id`, `channel`, `receipt`,
  `status`, `created_at`, `updated_at`
)
SELECT r.id, r.user_id, r.amount, '2026-09-26', '', '', '', '', 0, NOW(), NOW()
FROM `t_rent` r
JOIN `t_user` u ON u.id = r.user_id
WHERE u.account = '60666666666' AND r.deleted_at IS NULL
  AND NOT EXISTS (
    SELECT 1 FROM `t_rent_history` h WHERE h.rent_id = r.id AND h.last_paid_date = '2026-09-26'
  );

-- Due 15 Aug 2026, still unpaid. Wallet is empty.
INSERT INTO `t_rent` (
  `user_id`, `amount`, `file`, `paid_at`, `first_pay_month`, `lease_months`, `expire_date`,
  `property_id`, `property_name`, `landlord_id`, `owner_name`, `status`, `rejected_by`,
  `landlord_bank`, `landlord_bank_account`, `landlord_account_name`, `created_at`, `updated_at`
)
SELECT u.id, 1200.00, '/uploads/rent/local-test-agreement.jpg', 15, '2026-08-01', 12, '2027-07-01',
  NULL, 'Overdue Flat', NULL, 'Farid', 1, '',
  'Maybank', '444455556666', 'Farid', '2026-07-01 10:00:00', NOW()
FROM `t_user` u
WHERE u.account = '60777777777'
  AND NOT EXISTS (SELECT 1 FROM `t_rent` r WHERE r.user_id = u.id AND r.deleted_at IS NULL);

INSERT INTO `t_rent_history` (
  `rent_id`, `user_id`, `amount`, `last_paid_date`, `payment_method`, `txn_id`, `channel`, `receipt`,
  `status`, `created_at`, `updated_at`
)
SELECT r.id, r.user_id, r.amount, '2026-08-15', '', '', '', '', 0, NOW(), NOW()
FROM `t_rent` r
JOIN `t_user` u ON u.id = r.user_id
WHERE u.account = '60777777777' AND r.deleted_at IS NULL
  AND NOT EXISTS (
    SELECT 1 FROM `t_rent_history` h WHERE h.rent_id = r.id AND h.last_paid_date = '2026-08-15'
  );

-- August paid on time. Next due 28 Sep 2026. Wallet covers that month.
INSERT INTO `t_rent` (
  `user_id`, `amount`, `file`, `paid_at`, `first_pay_month`, `lease_months`, `expire_date`,
  `property_id`, `property_name`, `landlord_id`, `owner_name`, `status`, `rejected_by`,
  `landlord_bank`, `landlord_bank_account`, `landlord_account_name`, `created_at`, `updated_at`
)
SELECT u.id, 1600.00, '/uploads/rent/local-test-agreement.jpg', 28, '2026-08-01', 12, '2027-08-01',
  NULL, 'Partial Paid Home', NULL, 'Nora', 1, '',
  'Maybank', '555566667777', 'Nora', '2026-08-01 10:00:00', NOW()
FROM `t_user` u
WHERE u.account = '60888888888'
  AND NOT EXISTS (SELECT 1 FROM `t_rent` r WHERE r.user_id = u.id AND r.deleted_at IS NULL);

INSERT INTO `t_rent_history` (
  `rent_id`, `user_id`, `amount`, `last_paid_date`, `user_paid_at`, `payment_method`, `txn_id`,
  `channel`, `receipt`, `status`, `created_at`, `updated_at`
)
SELECT r.id, r.user_id, r.amount, '2026-08-28', '2026-08-27 09:00:00', 'wallet', '', '', '', 1, NOW(), NOW()
FROM `t_rent` r
JOIN `t_user` u ON u.id = r.user_id
WHERE u.account = '60888888888' AND r.deleted_at IS NULL
  AND NOT EXISTS (
    SELECT 1 FROM `t_rent_history` h WHERE h.rent_id = r.id AND h.last_paid_date = '2026-08-28'
  );

INSERT INTO `t_rent_history` (
  `rent_id`, `user_id`, `amount`, `last_paid_date`, `payment_method`, `txn_id`, `channel`, `receipt`,
  `status`, `created_at`, `updated_at`
)
SELECT r.id, r.user_id, r.amount, '2026-09-28', '', '', '', '', 0, NOW(), NOW()
FROM `t_rent` r
JOIN `t_user` u ON u.id = r.user_id
WHERE u.account = '60888888888' AND r.deleted_at IS NULL
  AND NOT EXISTS (
    SELECT 1 FROM `t_rent_history` h WHERE h.rent_id = r.id AND h.last_paid_date = '2026-09-28'
  );

UPDATE `t_user` SET `balance` = 1500.00 WHERE `account` = '60666666666';
UPDATE `t_user` SET `balance` = 0.00 WHERE `account` = '60777777777';
UPDATE `t_user` SET `balance` = 1600.00 WHERE `account` = '60888888888';
