WITH

ranked as (
    SELECT DISTINCT lane,mileage, 
    row_number() over (partition by lane order by mileage) as r,
    count(mileage) over (partition by lane) as c 
    FROM {{ ref ('stg_data_challenge') }} 
),

median as (
    SELECT DISTINCT lane, mileage 
    FROM ranked 
    WHERE r in (floor((c+1)/2), ceil((c+1)/2))
)

SELECT 
lane as lane_name,
avg(mileage) as mileage_median
FROM median
GROUP BY lane