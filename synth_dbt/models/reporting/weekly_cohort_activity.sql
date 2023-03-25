WITH cohort_new_users AS (
    SELECT
        *
    FROM
        {{ ref('int_cohorts__new_users') }}
),
cohort_weekly_activity AS (
    SELECT
        *
    FROM
        {{ ref('int_cohorts__user_activity') }}
),
/*
all_cohort_weeks as(
    SELECT *
    from sequence
)
all_activity_weeks
*/
--TODO: ADD SEQUENCE OF WEEKS TO CLEAR ANY GAPS
aggregated_users_activity AS (
    SELECT
        wa.cohort_week,
        wa.active_week,
        date_diff(
            wa.active_week,
            wa.cohort_week,
            week
        ) AS cohort_period,
        wa.user_segment,
        COUNT(
            wa.user_id_base64
        ) AS active_users,
        MAX (
            nu.new_users
        ) AS cohort_size
    FROM
        cohort_weekly_activity wa
        LEFT JOIN cohort_new_users nu
        ON wa.cohort_week = nu.cohort_week
        AND wa.user_segment = nu.segment
    GROUP BY
        1,
        2,
        3,
        4
)
SELECT
    *
FROM
    aggregated_users_activity
