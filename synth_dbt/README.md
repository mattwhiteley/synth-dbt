
## Setup:
Ensure you run `dbt deps` to install `dbt-utils` and `metrics` packages which are both required in this project

## BigQuery:
This project was developed on BigQuery, so ensure the correct adapter is installed: `pip3 install dbt-bigquery`
The SQL is fairly straightforward within these models, but YMMV if you attempt to run these models on Postgres or MySQL DBs.

## Docs:
Generate and serve the docs to view the DAG, and definitions across the whole project, including metrics and exposures
### `dbt docs generate`
### `dbt docs serve`


### Using this project
Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
