WITH fact__pageview_users AS (
  SELECT
    *
  FROM
    {{ ref('fact__pageviews_users') }}
),
user_activity AS (
  SELECT
    fpvu.user_id_base64,
    fpvu.user_segment,
    fpvu.cohort_week,
    DATE_TRUNC(
      fpvu.pageview_received_at_date_utc,
      isoweek
    ) AS active_week
  FROM
    fact__pageview_users AS fpvu
  WHERE
    fpvu.user_created_at_date_utc IS NOT NULL
    AND fpvu.pageview_received_at_date_utc IS NOT NULL
    AND fpvu.page_location IS NOT NULL
    AND fpvu.user_segment IN (
      'ENTERPRISE',
      'PERSONAL'
    )
  GROUP BY
    1,
    2,
    3,
    4
)
SELECT
  *
FROM
  user_activity
