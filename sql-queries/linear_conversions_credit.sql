-- DROP VIEW IF EXISTS linear_conv_credit;

CREATE VIEW linear_conv_credit AS
WITH user_touch_counts AS (
  SELECT						-- Step 1: count how many touches each user had
    user_pseudo_id
    , marketing_channel
    , COUNT(*) OVER(
      PARTITION BY user_pseudo_id
    ) AS total_touches
  FROM conv_history
  WHERE event_name != 'purchase'
)
SELECT
  marketing_channel
  , ROUND(SUM(1.0 / total_touches), 4) AS linear_conversion_credit -- Step 2: each row gets (1/Total Touches) credit
FROM user_touch_counts
GROUP BY marketing_channel
ORDER BY linear_conversion_credit DESC;