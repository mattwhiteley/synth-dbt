WITH pages_views as (
    SELECT * from {{ref ('pages_views')}}
),

rename_decodeGUID AS (
    SELECT
        pv.USER_ID as USER_ID_GUID,
        --Convert GUIDs to the shorter Base64 format, to match UserIDs
        to_base64(SAFE_CAST(REPLACE(USER_ID,"-","") AS BYTES FORMAT 'HEX')) as USER_ID_BASE64,
        -- Rename timestamp for clarity on timezone, separate date for day-only calcs
        pv.RECEIVED_AT as RECEIVED_AT_UTC,
        SAFE_CAST(RECEIVED_AT AS DATE) as RECEIVED_AT_DATE_UTC,
        pv.NAME as PAGE_LOCATION
    FROM pages_views pv
)

SELECT * FROM rename_decodeGUID