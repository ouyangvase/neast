-- 将系统管理权限名称更新为英文（角色权限树展示）

UPDATE `t_permission` SET `name` = 'System' WHERE `code` = 'sys';
UPDATE `t_permission` SET `name` = 'Employees' WHERE `code` = 'sys:employee';
UPDATE `t_permission` SET `name` = 'Create' WHERE `code` = 'sys:employee:create';
UPDATE `t_permission` SET `name` = 'Edit' WHERE `code` = 'sys:employee:update';
UPDATE `t_permission` SET `name` = 'Delete' WHERE `code` = 'sys:employee:delete';
UPDATE `t_permission` SET `name` = 'Toggle Status' WHERE `code` = 'sys:employee:status';
UPDATE `t_permission` SET `name` = 'Reset Password' WHERE `code` = 'sys:employee:reset';
UPDATE `t_permission` SET `name` = 'Roles' WHERE `code` = 'sys:role';
UPDATE `t_permission` SET `name` = 'Create' WHERE `code` = 'sys:role:create';
UPDATE `t_permission` SET `name` = 'Edit' WHERE `code` = 'sys:role:update';
UPDATE `t_permission` SET `name` = 'Delete' WHERE `code` = 'sys:role:delete';
