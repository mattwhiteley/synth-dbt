WITH dim__users AS (
    SELECT
        *
    FROM
        {{ ref('dim__users') }}
),
new_users AS (
    SELECT
        u.cohort_week,
        u.segment as user_segment,
        COUNT(
            DISTINCT u.user_id_base64
        ) AS new_users
    FROM
        dim__users u
    GROUP BY
        1,
        2
)
SELECT
    *
FROM
    new_users
