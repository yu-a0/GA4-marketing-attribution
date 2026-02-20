SELECT DISTINCT
  event_name
  , traffic_source.medium
  , traffic_source.source
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20210107'