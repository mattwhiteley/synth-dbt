with pages_views as (
    SELECT * from {{ref ('pages_views')}}
)

-- rename to UTC
-- format USER IDs

SELECT
    pv.USER_ID,
    pv.RECEIVED_AT,
    pv.NAME
FROM pages_views pv