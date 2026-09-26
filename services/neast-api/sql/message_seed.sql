-- 三端消息测试数据

SET @user_id = (SELECT `id` FROM `t_user` ORDER BY `id` ASC LIMIT 1);
SET @landlord_id = (SELECT `id` FROM `t_landlord` ORDER BY `id` ASC LIMIT 1);
SET @merchant_id = (SELECT `id` FROM `t_merchant` ORDER BY `id` ASC LIMIT 1);

INSERT INTO `t_message_user` (`user_id`, `title`, `content`, `is_read`, `created_at`, `updated_at`)
SELECT @user_id, 'Rent day reminder', 'Your rent will be due in 3 working days, amounting to 3000 yuan.', 0, DATE_SUB(NOW(), INTERVAL 2 HOUR), NOW()
WHERE @user_id IS NOT NULL
UNION ALL
SELECT @user_id, 'Points credited to account', 'You have received 30 points after paying 3000 yuan for rent on the platform.', 0, DATE_SUB(NOW(), INTERVAL 1 DAY), NOW()
WHERE @user_id IS NOT NULL
UNION ALL
SELECT @user_id, 'Coupon expiring soon', 'Your coupon will expire in 7 days. Redeem it at a participating merchant.', 1, DATE_SUB(NOW(), INTERVAL 3 DAY), NOW()
WHERE @user_id IS NOT NULL
UNION ALL
SELECT @user_id, 'Welcome to Neast', 'Thank you for joining Neast. Start paying rent and earning points today.', 1, DATE_SUB(NOW(), INTERVAL 7 DAY), NOW()
WHERE @user_id IS NOT NULL;

INSERT INTO `t_message_landlord` (`landlord_id`, `title`, `content`, `is_read`, `created_at`, `updated_at`)
SELECT @landlord_id, 'Rent payment received', 'Tenant has paid rent for April 2026. Please confirm receipt.', 0, DATE_SUB(NOW(), INTERVAL 1 HOUR), NOW()
WHERE @landlord_id IS NOT NULL
UNION ALL
SELECT @landlord_id, 'New bind request', 'A tenant has requested to bind a new property to your account.', 0, DATE_SUB(NOW(), INTERVAL 6 HOUR), NOW()
WHERE @landlord_id IS NOT NULL
UNION ALL
SELECT @landlord_id, 'Settlement completed', 'Platform has settled your rent payment for March 2026.', 1, DATE_SUB(NOW(), INTERVAL 2 DAY), NOW()
WHERE @landlord_id IS NOT NULL
UNION ALL
SELECT @landlord_id, 'Account verified', 'Your landlord account has been verified successfully.', 1, DATE_SUB(NOW(), INTERVAL 5 DAY), NOW()
WHERE @landlord_id IS NOT NULL;

INSERT INTO `t_message_merchant` (`merchant_id`, `title`, `content`, `is_read`, `created_at`, `updated_at`)
SELECT @merchant_id, 'New redemption', 'A customer has redeemed a coupon at your store.', 0, DATE_SUB(NOW(), INTERVAL 30 MINUTE), NOW()
WHERE @merchant_id IS NOT NULL
UNION ALL
SELECT @merchant_id, 'Daily closing reminder', 'Please complete your daily closing before end of business.', 0, DATE_SUB(NOW(), INTERVAL 4 HOUR), NOW()
WHERE @merchant_id IS NOT NULL
UNION ALL
SELECT @merchant_id, 'Points top-up success', 'Your merchant points balance has been topped up successfully.', 1, DATE_SUB(NOW(), INTERVAL 1 DAY), NOW()
WHERE @merchant_id IS NOT NULL
UNION ALL
SELECT @merchant_id, 'Welcome to Neast Merchant', 'Your merchant account is now active. Start accepting redemptions.', 1, DATE_SUB(NOW(), INTERVAL 10 DAY), NOW()
WHERE @merchant_id IS NOT NULL;
