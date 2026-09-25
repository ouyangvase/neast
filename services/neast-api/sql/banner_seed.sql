-- Home campaign slides. Images live in public/uploads/banner. Idempotent.

INSERT INTO `t_banner` (`image`, `link`, `sort`, `status`, `starts_at`, `ends_at`, `created_at`, `updated_at`)
SELECT '/uploads/banner/yoyo-luckin-campaign.png', 'https://www.sina.cn/news/detail/5339379767444744.html', 30, 1, NULL, NULL, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `t_banner` WHERE `image` = '/uploads/banner/yoyo-luckin-campaign.png');

INSERT INTO `t_banner` (`image`, `link`, `sort`, `status`, `starts_at`, `ends_at`, `created_at`, `updated_at`)
SELECT '/uploads/banner/campaign-sample-city.png', 'https://neast.my', 20, 1, NULL, NULL, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `t_banner` WHERE `image` = '/uploads/banner/campaign-sample-city.png');

INSERT INTO `t_banner` (`image`, `link`, `sort`, `status`, `starts_at`, `ends_at`, `created_at`, `updated_at`)
SELECT '/uploads/banner/campaign-sample-home.png', 'https://neast.my', 10, 1, NULL, NULL, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `t_banner` WHERE `image` = '/uploads/banner/campaign-sample-home.png');
