WITH stg_seed__pagesviews AS (
    SELECT
        *
    FROM
        {{ ref('stg_seed__pagesviews') }}
),
dim__users AS (
    SELECT
        *
    FROM
        {{ ref('dim__users') }}
),
join_transform AS (
    SELECT
        u.user_id_base64 AS user_id_base64,
        pv.received_at_utc AS pageview_received_at_utc,
        pv.received_at_date_utc AS pageview_received_at_date_utc,
        pv.page_location,
        u.created_at_utc AS user_created_at_utc,
        u.created_at_date_utc AS user_created_at_date_utc,
        u.segment AS user_segment,
        u.is_internal AS user_is_internal,
        u.cohort_week
    FROM
        stg_seed__pagesviews AS pv
        INNER JOIN dim__users AS u  -- only join events where IDs exist in both tables
        ON pv.user_id_base64 = u.user_id_base64
    WHERE
        u.user_id_base64 IS NOT NULL
        AND pv.user_id_base64 IS NOT NULL
)
SELECT
    *
FROM
    join_transform
