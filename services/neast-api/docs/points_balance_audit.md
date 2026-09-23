# 用户积分字段说明

> 用户可用积分来自 `t_user_points` 未过期记录之和；API 字段为 `points`。

## 数据来源

```sql
SELECT COALESCE(SUM(points), 0)
FROM t_user_points
WHERE user_id = ? AND expired_date >= CURDATE()
```

实现：`UserPointsService::availableBalance()`

## API

| 接口 | 字段 |
|------|------|
| `GET /app/user/info` | `points` |
| `GET /app/reward/dashboard` | `points`、`pointsExpiringText` |
| `GET /admin/user/list` | `points` |

## 写入 / 扣减

- 商家发放：`GivePointsService` → `UserPointsService::grant()`（30 天过期）
- 优惠券兑换：`CouponService::appRedeem` → `UserPointsService::deduct()`（先过期先扣，事务内）

## 已移除

- `t_user.points_balance` 列（见 `sql/user_drop_points_balance.sql`）
