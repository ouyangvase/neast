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
