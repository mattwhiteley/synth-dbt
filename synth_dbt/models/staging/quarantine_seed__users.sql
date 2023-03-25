WITH users AS (
    SELECT
        *
    FROM
        {{ ref ('users') }}
),
rename_convert_dates AS (
    SELECT
        u.user_id AS user_id_base64,
        --Convert string timestamp to DATETIME and DATE formats
        parse_datetime(
            '%FT%R:%E*SZ',
            u.created_at
        ) AS created_at_utc,
        safe_cast(parse_datetime('%FT%R:%E*SZ', u.created_at) AS DATE) AS created_at_date_utc,
        u.segment,
        u.is_internal
    FROM
        users u
),
quarantine_rows AS (
    SELECT
        *
    FROM
        rename_convert_dates rcd
    WHERE
        rcd.user_id_base64 IS NULL
        OR rcd.created_at_utc IS NULL
        OR rcd.created_at_date_utc IS NULL
        OR rcd.is_internal IS NULL
)
SELECT
    *
FROM
    quarantine_rows
