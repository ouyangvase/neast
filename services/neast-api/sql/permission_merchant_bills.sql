-- Merchant Bills 独立菜单：权限名称更新与废弃按钮权限清理

UPDATE `t_permission`
SET `name` = 'Bills', `updated_at` = NOW()
WHERE `code` = 'merchant:bill';

DELETE FROM `t_permission`
WHERE `code` = 'merchant:list:bills';

UPDATE `t_admin_role`
SET
  `permissions` = CAST(
    REPLACE(
      CAST(`permissions` AS CHAR),
      '"merchant:list:bills"',
      '"merchant:bill"'
    ) AS JSON
  ),
  `updated_at` = NOW()
WHERE `code` <> 'ADMIN'
  AND `permissions` IS NOT NULL
  AND JSON_CONTAINS(`permissions`, '"merchant:list:bills"');
