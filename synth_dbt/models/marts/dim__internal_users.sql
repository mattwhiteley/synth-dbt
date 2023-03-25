WITH stg_seed__users AS (
    SELECT
        *
    FROM
        {{ ref('stg_seed__users') }}
),
enriched_only_internal_users AS (
    SELECT
        su.user_id_base64,
        su.created_at_utc,
        su.created_at_date_utc,
        su.segment,
        su.is_internal,
        DATE_TRUNC(
            su.created_at_date_utc,
            isoweek
        ) AS cohort_week
    FROM
        stg_seed__users su
    WHERE
        su.is_internal = TRUE
)
SELECT
    *
FROM
    enriched_only_internal_users
