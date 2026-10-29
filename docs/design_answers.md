
# Mortgage Underwriting Pipeline - Design Answers

## 1. Calculate LTV

Loan-to-Value (LTV) measures the loan amount against the property value.

Formula:

LTV = (Loan Amount / Property Value) * 100

Example:
Loan Amount = 400000
Property Value = 500000
LTV = 80%

Business Rule:
If LTV > 95%, decline the application.

## 2. Calculate DTI

Debt-to-Income (DTI) measures monthly debt against monthly gross income.

Formula:

DTI = (Monthly Debt / Monthly Gross Income) * 100

Example:
Monthly Debt = 2000
Monthly Income = 5000
DTI = 40%

Business Rule:
If DTI > 43%, decline the application.

## 3. Handle Delayed Credit Bureau Data

1. Load mortgage applications into RAW.
2. Track whether credit data has arrived.
3. Do not make a final underwriting decision without required credit data.
4. Retry the credit-bureau ingestion.
5. Log missing data and alert the support team.
6. Reprocess the application when credit data arrives.

## 4. Mask Sensitive Data

- Store SSN as a string to preserve leading zeros.
- Mask SSN and applicant name for general analysts.
- Grant unmasked access only to authorized compliance users.
- Use Snowflake masking policies and role-based access control.
- Never commit real applicant data or credentials to GitHub.

## 5. Audit Changes Using Time Travel

Snowflake Time Travel can help investigate historical table data within the configured retention period.

For a table with sufficient retention, an authorized user can query its state from 30 days earlier:

SELECT *
FROM MORTGAGE_DB.GOLD.FCT_UNDERWRITING_DECISIONS
AT (OFFSET => -2592000);

Note:
30-day Time Travel requires the appropriate Snowflake edition and retention configuration. This query is for historical investigation, not a replacement for a permanent audit log.

## 6. Handle a 1000x Weekend Data Spike

1. Monitor file arrival rate and ingestion backlog.
2. Use scalable ingestion and appropriately sized compute.
3. Process data in batches or micro-batches where suitable.
4. Make ingestion idempotent to prevent duplicate records.
5. Monitor warehouse usage, query duration, and failures.
6. Alert support when backlog or latency exceeds thresholds.
7. Validate record counts and data quality after processing.

## 7. Data Quality and Rejections

- Reject records with missing applicant IDs.
- Reject records with invalid loan amounts or property values.
- Reject records with missing credit scores or income.
- Store technical rejection reasons for investigation.
- Separate technical data-quality rejections from business underwriting declines.

## 8. Orchestration

Airflow coordinates the workflow:

1. Load mortgage application data.
2. Load credit bureau data.
3. Wait for both loading tasks to succeed.
4. Run dbt Silver transformations.
5. Run dbt Gold underwriting models.
6. Execute data quality tests.
7. Retry failures and notify support.

## 9. Regulatory Reporting

The Gold layer provides underwriting decisions and reason codes for analytics and reporting.

Additional regulatory attributes, validation, and reporting controls are required before claiming full HMDA compliance.

## 10. Important Production Improvements

- Add persistent ingestion and underwriting audit tables.
- Add incremental processing and duplicate prevention.
- Configure Snowflake RBAC and masking policies.
- Add automated dbt tests and pipeline monitoring.
- Store credentials in a secrets manager.
- Validate all SQL, dbt, Terraform, and Airflow code in a configured environment.
