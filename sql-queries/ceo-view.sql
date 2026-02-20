WITH first_touch_summary AS (
	SELECT
	COUNT(DISTINCT user_pseudo_id)			AS first_touch_total
	, first_touch_channel					AS channel
	FROM (
		SELECT
			user_pseudo_id
			, FIRST_VALUE(marketing_channel)
				OVER(
					PARTITION BY user_pseudo_id
					ORDER BY event_time ASC
					)						AS first_touch_channel
		FROM stg_attribution
		WHERE event_name != 'purchase' 
	) GROUP BY channel
),
last_touch_summary AS (
	SELECT
	COUNT(DISTINCT user_pseudo_id)			AS last_touch_total
	, last_touch_channel					AS channel
	FROM (
		SELECT
			user_pseudo_id
			, LAST_VALUE(marketing_channel)
				OVER(
					PARTITION BY user_pseudo_id
					ORDER BY event_time ASC
					ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
					)						AS last_touch_channel
		FROM stg_attribution
		WHERE event_name != 'purchase' 
	) GROUP BY channel
),
linear_summary AS (
	SELECT
		marketing_channel AS channel
		, SUM(linear_conversion_credit) AS linear_total
	FROM linear_conv_credit
	GROUP BY 1
),
ceo_view_results AS (
	SELECT
		f.channel
		, f.first_touch_total				AS first_touch
		, l.last_touch_total				AS last_touch
		, ROUND(lin.linear_total, 2)		AS linear
	FROM first_touch_summary f
		JOIN last_touch_summary l ON f.channel = l.channel
		JOIN linear_summary lin ON f.channel = lin.channel
),
totals AS (
	SELECT
		SUM(first_touch)					AS total_ft
		, SUM(last_touch)					AS total_lt
		, SUM(linear)						AS total_lin
	FROM ceo_view_results
)
SELECT
	channel
	, ROUND((first_touch * 100.0 / total_ft), 2)		AS first_touch_pct
	, ROUND((last_touch * 100.0 / total_lt), 2)			AS last_touch_pct
	, ROUND((linear * 100.0 / total_lin), 2)			AS linear_pct
FROM ceo_view_results, totals
ORDER BY last_touch_pct DESC;