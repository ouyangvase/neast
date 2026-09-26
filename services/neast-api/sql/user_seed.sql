-- Default login user for local development. Idempotent.
INSERT INTO `t_user` (
  `account`,
  `email`,
  `password`,
  `first_name`,
  `last_name`,
  `id_type`,
  `id_number`,
  `address`,
  `invitation_code`,
  `status`,
  `tent_score`,
  `created_at`,
  `updated_at`
)
SELECT
  '60123456789',
  'alex.demo@neast.local',
  '',
  'Alex',
  'Demo',
  'id_card',
  '900101145678',
  'Johor Bahru',
  'DEMO1001',
  1,
  500,
  NOW(),
  NOW()
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM `t_user` WHERE `account` = '60123456789'
);

-- Fresh login user: completed profile, no tenancy. Idempotent.
INSERT INTO `t_user` (
  `account`,
  `email`,
  `password`,
  `first_name`,
  `last_name`,
  `id_type`,
  `id_number`,
  `address`,
  `invitation_code`,
  `status`,
  `tent_score`,
  `created_at`,
  `updated_at`
)
SELECT
  '60111111111',
  'fresh.tenant@neast.local',
  '',
  'Fresh',
  'Tenant',
  'id_card',
  '910202145678',
  'Johor Bahru',
  'FRESH1002',
  1,
  500,
  NOW(),
  NOW()
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM `t_user` WHERE `account` = '60111111111'
);

-- State fixtures. OTP 123456. No tenancy rows here; see user_tenancy_state_seed.sql.
INSERT INTO `t_user` (
  `account`, `email`, `password`, `first_name`, `last_name`, `id_type`, `id_number`,
  `address`, `invitation_code`, `status`, `tent_score`, `created_at`, `updated_at`
)
SELECT '60222222222', 'pending.review@neast.local', '', 'Pending', 'Review', 'id_card', '920101010002', 'Johor Bahru', 'PEND1003', 1, 500, NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `t_user` WHERE `account` = '60222222222')
UNION ALL
SELECT '60333333333', 'awaiting.owner@neast.local', '', 'Awaiting', 'Owner', 'id_card', '920101010003', 'Johor Bahru', 'BIND1004', 1, 500, NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `t_user` WHERE `account` = '60333333333')
UNION ALL
SELECT '60444444444', 'rejected.admin@neast.local', '', 'Rejected', 'Admin', 'id_card', '920101010004', 'Johor Bahru', 'REJA1005', 1, 500, NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `t_user` WHERE `account` = '60444444444')
UNION ALL
SELECT '60555555555', 'rejected.owner@neast.local', '', 'Rejected', 'Owner', 'id_card', '920101010005', 'Johor Bahru', 'REJO1006', 1, 500, NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `t_user` WHERE `account` = '60555555555')
UNION ALL
SELECT '60666666666', 'ready.pay@neast.local', '', 'Ready', 'Pay', 'id_card', '920101010006', 'Johor Bahru', 'PAY1007', 1, 500, NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `t_user` WHERE `account` = '60666666666')
UNION ALL
SELECT '60777777777', 'overdue.rent@neast.local', '', 'Overdue', 'Rent', 'id_card', '920101010007', 'Johor Bahru', 'LATE1008', 1, 500, NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `t_user` WHERE `account` = '60777777777')
UNION ALL
SELECT '60888888888', 'partial.paid@neast.local', '', 'Partial', 'Paid', 'id_card', '920101010008', 'Johor Bahru', 'PART1009', 1, 500, NOW(), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `t_user` WHERE `account` = '60888888888');
