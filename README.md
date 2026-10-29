
# Mortgage Application & Underwriting Pipeline

## Project Overview

This project demonstrates an end-to-end mortgage underwriting data
pipeline using Snowflake, dbt, Apache Airflow, Python, SQL, and Terraform.

The pipeline ingests mortgage application JSON data and credit bureau
CSV data, validates records, calculates underwriting metrics, and
produces decisions for analytics and reporting.

## Architecture

Source JSON + Credit Bureau CSV
          |
          v
Snowflake RAW Layer
          |
          v
dbt SILVER Layer
  - Standardization
  - Application and credit data join
  - Technical rejection handling
          |
          v
dbt GOLD Layer
  - LTV calculation
  - DTI calculation
  - Credit score rules
  - Decision status and reason codes
          |
          v
Reporting and Analytics

Apache Airflow orchestrates the ingestion and transformation tasks.
Terraform defines Snowflake infrastructure resources.

## Technology Stack

- Snowflake: Data warehouse and SQL processing
- dbt: Data transformation and data quality tests
- Apache Airflow: Pipeline orchestration
- Python: Workflow code
- SQL: Data ingestion and business rules
- Terraform: Infrastructure as code
- GitHub: Source control and documentation

## Business Rules

### Loan-to-Value (LTV)

LTV = (Loan Amount / Property Value) * 100

Applications with LTV greater than 95% are declined.

### Debt-to-Income (DTI)

DTI = (Monthly Debt / Monthly Gross Income) * 100

Applications with DTI greater than 43% are declined.

### Credit Score

- Credit score below 620: Declined
- Credit score from 620 to 660 with DTI from 36% to 43%:
  Requires co-signer
- Other valid applications: Evaluated using the configured rules

These are illustrative case-study rules, not actual lender policy.

## Repository Structure

- data/: Synthetic source data
- snowflake/: Database setup and ingestion SQL
- dbt_mortgage/models/silver/: Staging and integration models
- dbt_mortgage/models/gold/: Underwriting decisions
- dbt_mortgage/macros/: Reusable SQL macros
- dags/: Airflow orchestration
- terraform/: Infrastructure definitions
- docs/: Architecture and design decisions

## Data Quality

The pipeline identifies missing or invalid critical fields and records
technical rejection reasons separately from underwriting decisions.

dbt tests are defined for key identifiers and decision statuses.

## Security

- Use synthetic data only.
- Mask sensitive applicant information.
- Apply role-based access controls.
- Store credentials outside source control.
- Do not commit real SSNs, passwords, tokens, or private keys.

## Setup and Execution

This repository currently contains source-code examples and configuration
templates.

Before execution, configure Snowflake credentials, upload the synthetic
source files to the required Snowflake stages, configure the dbt profile,
install the required Airflow and Terraform dependencies, and validate
provider versions and permissions.

Run dbt tests in a configured environment before relying on the results.

## Testing Status

Execution and deployment must be verified in a configured environment.
The presence of source files in GitHub does not by itself demonstrate
that the pipeline has run successfully.

## Future Improvements

- Persistent audit and rejection logging
- Incremental processing and duplicate prevention
- Automated failure notifications
- CI/CD validation
- Monitoring and cost optimization
- Additional regulatory reporting fields and controls
