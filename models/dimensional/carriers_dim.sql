WITH

grouped_vars as (
    SELECT
    carrier_name,
    SUM(carrier_dropped_us_count) as max_dropped_us_count,
    MIN(quote_date) as first_quote_date
    FROM {{ ref ('stg_data_challenge') }} 
    GROUP BY carrier_name
)

SELECT DISTINCT

SUBSTRING(sourc.carrier_name,8) as carrier_id,
CAST(sourc.vip_carrier as boolean) as vip_carrier,
CAST(sourc.has_macropoint_tracking as boolean) as has_macropoint_tracking, 
CAST(sourc.has_edi_tracking as boolean) as has_edi_tracking,
CAST(sourc.has_mobile_app_tracking as boolean) as has_mobile_app_tracking,
grouped_vars.max_dropped_us_count as carrier_dropped_us_count_total,
CAST(grouped_vars.first_quote_date as timestamp) as carrier_first_quote_date

FROM {{ ref ('stg_data_challenge') }} as sourc
LEFT JOIN grouped_vars using(carrier_name)
WHERE grouped_vars.carrier_name is not null

