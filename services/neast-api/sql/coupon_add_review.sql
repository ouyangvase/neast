-- Voucher publish gate. Existing rows stay admin + approved so coupons already on the app remain visible.

ALTER TABLE `t_coupon`
  ADD COLUMN `origin` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'admin' COMMENT '来源 admin管理员 merchant商家' AFTER `status`,
  ADD COLUMN `review_status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'approved' COMMENT '审核 pending待审 approved通过 rejected拒绝' AFTER `origin`;
