--DROP VIEW IF EXISTS touch_conv;

--CREATE VIEW touch_conv AS
WITH attribution_results AS (
  SELECT
    user_pseudo_id
	, marketing_channel
    , FIRST_VALUE(marketing_channel) OVER(
        PARTITION BY user_pseudo_id
        ORDER BY event_time ASC
      )										AS first_touch_channel	-- First channel the user used
    , LAST_VALUE(marketing_channel) OVER(
        PARTITION BY user_pseudo_id
        ORDER BY event_time ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      )										AS last_touch_channel	-- Last channel before purchase
  FROM stg_attribution
  WHERE event_name != 'purchase'
)
SELECT
  channel
  , SUM(first_touch_points)					AS first_touch_conversions
  , SUM(last_touch_points)					AS last_touch_conversions
FROM (
	-- Pivot first touch counts
  SELECT first_touch_channel AS channel, 1 AS first_touch_points, 0 As last_touch_points
  FROM (SELECT DISTINCT user_pseudo_id, first_touch_channel FROM attribution_results)
  UNION ALL
	-- Pivot last touch counts
  SELECT last_touch_channel AS channel, 0 AS first_touch_points, 1 AS last_touch_points
  FROM (SELECT DISTINCT user_pseudo_id, last_touch_channel FROM attribution_results)
)
GROUP BY channel
ORDER BY last_touch_conversions DESC;