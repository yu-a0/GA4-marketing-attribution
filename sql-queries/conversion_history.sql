-- DROP VIEW IF EXISTS conversion_history;

CREATE VIEW conv_history AS
WITH converted_users AS (
  SELECT
    user_pseudo_id
    , event_time AS conversion_time
  FROM stg_attribution
  WHERE event_name = 'purchase'
)
SELECT
  stg.user_pseudo_id
  , stg.event_time
  , stg.event_name
  , stg.marketing_channel
  , stg.purchase_revenue_in_usd
  , stg.total_item_quantity
  , conv.conversion_time
FROM stg_attribution AS stg
INNER JOIN converted_users AS conv
  ON stg.user_pseudo_id = conv.user_pseudo_id
WHERE stg.event_time <= conv.conversion_time -- Only look at the path leading to the sale