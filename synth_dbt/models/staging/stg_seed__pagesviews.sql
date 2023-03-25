WITH pages_views AS (
    SELECT
        *
    FROM
        {{ ref ('pages_views') }}
),
rename_decodeGUID_dedupe AS (
    SELECT
        pv.user_id AS user_id_guid,
        --Convert GUIDs to the shorter Base64 format, to match users.UserIDs - Bad IDs will resolve to Nulls
        to_base64(
            safe_cast(REPLACE(pv.user_id, "-", "") AS bytes format 'HEX')
        ) AS user_id_base64,
        -- Rename timestamp for clarity on timezone, separate date for day-only calcs
        pv.received_at AS received_at_utc,
        safe_cast(
            pv.received_at AS DATE
        ) AS received_at_date_utc,
        pv.name AS page_location,
        COUNT(*) as row_count --row count for group & dedupe
    FROM
        pages_views pv
    GROUP BY 1,2,3,4,5
    HAVING COUNT(*) = 1 --removes duplicate rows
),
remove_NULL_rows AS (
    SELECT
        user_id_guid,
        user_id_base64,
        received_at_utc,
        received_at_date_utc,
        page_location
    FROM
        rename_decodeGUID_dedupe rd
    WHERE
        rd.user_id_guid IS NOT NULL
        AND rd.user_id_base64 IS NOT NULL
        AND rd.page_location IS NOT NULL 
)
SELECT
    *
FROM
    remove_NULL_rows
