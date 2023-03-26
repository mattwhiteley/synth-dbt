WITH cohort_new_users AS (
    SELECT
        *
    FROM
        {{ ref('int_cohorts__new_users') }}
),

weekly_metrics AS(
    SELECT
        *
    from 
        {{ metrics.calculate(
            metric('weekly_active_users'),
            grain='week',
            dimensions=['cohort_week', 'user_segment']
        )
    }}
),

aggregated_users_activity_metrics AS (
    SELECT
        wm.cohort_week,
        wm.date_week as active_week,
        date_diff(
            wm.date_week,
            wm.cohort_week,
            week
        ) AS cohort_period,
        wm.user_segment,
        wm.weekly_active_users,
        MAX (
            nu.new_users
        ) AS cohort_size
    FROM
        weekly_metrics wm
        LEFT JOIN cohort_new_users nu
        ON wm.cohort_week = nu.cohort_week
        AND wm.user_segment = nu.user_segment
    GROUP BY
        1,
        2,
        3,
        4,
        5
)

SELECT
    *
FROM
    aggregated_users_activity_metrics
