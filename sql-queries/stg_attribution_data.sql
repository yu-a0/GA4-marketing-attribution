CREATE OR REPLACE TABLE `project-34b6f3d2-0f4a-4ee2-b1a.marketing_attribution.stg_attribution_data` AS
SELECT
  user_pseudo_id
  , TIMESTAMP_MICROS(event_timestamp) AS event_time
  , event_name
  , CASE
      WHEN traffic_source.source IS NULL OR traffic_source.source IN ('(data deleted)', '<Other>')
        THEN 'Uncategorized'
      WHEN traffic_source.source = '(direct)'
        THEN 'Direct'
      ELSE traffic_source.source
    END AS clean_source
  , CASE
      WHEN traffic_source.medium = 'cpc'
        THEN 'Paid Search'
      WHEN traffic_source.medium = 'organic'
        THEN 'Organic Search'
      WHEN traffic_source.medium = 'referral'
        THEN 'Referral'
      WHEN traffic_source.medium IN ('(none)', 'direct')
        THEN 'Direct'
      WHEN traffic_source.medium IN ('<Other>', '(data deleted)')
        THEN 'Uncategorized'
      ELSE 'Other'
    END AS marketing_channel
  , ecommerce
  , (SELECT
        value.string_value
    FROM UNNEST(event_params)
    WHERE key = 'page_location'
    LIMIT 1)    AS page_location
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name IN ('session_start', 'purchase', 'first_visit')
  AND _TABLE_SUFFIX BETWEEN '20210101' AND '20210107'