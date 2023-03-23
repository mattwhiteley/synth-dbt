with users as (
    SELECT * from {{ref ('users')}}
),

rename_convertDates as (SELECT
    u.USER_ID as USER_ID_BASE64,
    --Convert string timestamp to DATETIME and DATE formats
    PARSE_DATETIME('%FT%R:%E*SZ',u.CREATED_AT) as CREATED_AT_UTC,
    SAFE_CAST(PARSE_DATETIME('%FT%R:%E*SZ',u.CREATED_AT) as DATE) as CREATED_AT_DATE_UTC,
    u.SEGMENT,
    u.IS_INTERNAL
FROM users u
)

select * from rename_convertDates