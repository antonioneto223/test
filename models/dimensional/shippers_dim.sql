SELECT 

SUBSTRING(shipper_name,8) as shipper_id,
MIN(quote_date) as first_quote_date

FROM {{ ref ('stg_data_challenge') }} 
GROUP BY shipper_id