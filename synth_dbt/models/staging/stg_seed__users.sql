with users as (
    SELECT * from {{ref ('users')}}
)

-- CReated AT datestamps
-- rename UTC

SELECT
    u.USER_ID,
    u.CREATED_AT,
    u.SEGMENT,
    u.IS_INTERNAL
FROM users u