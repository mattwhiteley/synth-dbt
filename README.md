# synth-dbt
dbt repo for synthesia test

## Outline:
The pipeline uses a standard structure for staging > marts > intermediate > reporting, making use of Metrics and Exposures features of dbt. This diagram is available in the dbt docs:

![Screenshot of dbt dag](https://github.com/mattwhiteley/synth-dbt/blob/main/synth-dbt-dag.jpg?raw=true)

## Dashboard:
The Cohort Chart is visualised on a [Looker Dashboard](https://lookerstudio.google.com/s/qO90YacICXs). One future improvement would be to add the Cohort Size to the rows, so it's clear you're comparing across similar sizes for retention %, although for now the volume of new users across each segement doesn't appear to be significantly disparate.

I found that there are users created within the date range of the pagesviews data, with no tracked activity. Normally you would expect some log of activity to bring Week 0 %s to 100%, but the lack of any data for those users brings the Week 0 metric down.

## Additional features:
- **Quarantine:** Rows not meeting the cleaning criteria at staging have been quarantined for inspection. In most cases here the data is not salvageable within the context of this task and the data available (eg nulls or malformed IDs).
- **Internal Users:** Separated out so they're still available for other purposes.

## Data Handling decisions:
- **Null Values in Users Table:** Nulls were found in 785 'created_at' values. While quarantining these removed c.57k pageviews from the dataset only 2 of those pageviews referenced '/signup' pages, where using the 'received_at' date as a proxy for 'created_at' could have been viable. Hence I prefer to quarantine these rows, and seek a better way, than to use the MIN(received_at) timestamp to estimate a 'created_at' date and potentially pollute other cohorts.
- **Malformed User IDs:** I've quarantined the UserIDs that do not meet UUID4 formats, and thus can't be encoded correctly into base64.
- **Duplicated Page Views:** I've deduped these rows for clarity, although they would not affect the cohort analysis here, as we're just looking to see IF a user has been active, not at the volume of activity.
- **Malformed Page Names:** I've carried these through the pipeline without cleaning at this stage, given that our app has 'seen' this user, and recorded an event. I would anticipate a decision on how we handle, or split down these pages to different points on some product usage framework, would be a point beyond the scope of this task.

## BigQuery Adapter
These models are running on a BigQuery dataset, so while you might get away with this SQL running on a different database, I recommend setting up a BigQuery connection during 'dbt init' and ensure you're using the dbt-bigquery adapter:
### `pip3 install dbt-bigquery`