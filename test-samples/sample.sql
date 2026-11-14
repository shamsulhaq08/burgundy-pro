-- PostgreSQL / SQL Server Query Sample
-- Burgundy Pro Syntax Test

WITH active_subscriptions AS (
    SELECT 
        u.user_id,
        u.username,
        u.email,
        s.plan_name,
        s.monthly_rate,
        s.started_at,
        ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY s.started_at DESC) AS rank_order
    FROM users u
    INNER JOIN subscriptions s ON u.user_id = s.user_id
    WHERE s.status = 'ACTIVE'
      AND s.expires_at > CURRENT_TIMESTAMP
)
SELECT 
    user_id,
    username,
    email,
    plan_name,
    monthly_rate,
    started_at
FROM active_subscriptions
WHERE rank_order = 1
ORDER BY monthly_rate DESC, username ASC
LIMIT 50;
