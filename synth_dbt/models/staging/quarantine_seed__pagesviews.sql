WITH pages_views AS (
    SELECT
        *
    FROM
        {{ ref ('pages_views') }}
),
rename_decodeGUID AS (
    SELECT
        pv.user_id AS user_id_guid,
        --Convert GUIDs to the shorter Base64 format, to match users.UserIDs - Bad IDs will resolve to Nulls
        to_base64(
            safe_cast(REPLACE(pv.user_id, "-", "") AS bytes format 'HEX')
        ) AS user_id_base64,
        pv.received_at,
        pv.name,
        COUNT(*) as row_count
    FROM
        pages_views pv
    GROUP BY 1,2,3,4
),
quarantine_rows AS (
    SELECT
        *
    FROM
        rename_decodeGUID rd
    WHERE
        rd.user_id_guid IS NULL
        OR rd.user_id_base64 IS NULL
        OR rd.received_at IS NULL
        OR rd.name IS NULL
        OR rd.row_count > 1 
)
SELECT
    *
FROM
    quarantine_rows
