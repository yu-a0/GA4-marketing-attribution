CREATE VIEW linear_conv_revenue AS
WITH revenue_extract AS (
  SELECT
    user_pseudo_id
    , event_time
    , marketing_channel
    , event_name
					-- Get revenue only for the purchase event
    , MAX(
      CASE
        WHEN event_name = 'purchase'
        THEN total_item_quantity
        ELSE 0
      END) OVER(PARTITION BY user_pseudo_id)	AS total_items
    , MAX(
      CASE
        WHEN event_name = 'purchase'
        THEN purchase_revenue_in_usd
        ELSE 0
      END) OVER (PARTITION BY user_pseudo_id)	AS total_revenue
  FROM conv_history
),
touch_counts AS (
  SELECT
    *
    , COUNT(*) OVER(
        PARTITION BY user_pseudo_id
    ) AS total_touches
  FROM revenue_extract
  WHERE event_name != 'purchase'
)
SELECT
  marketing_channel
  , ROUND(SUM(
    total_revenue / total_touches)
    , 2)                                    AS linear_revenue_attributed
  , ROUND(SUM(
    1.0 / total_touches)
    , 2)                                    AS linear_conversions
FROM touch_counts
GROUP BY 1
ORDER BY linear_revenue_attributed DESC;

