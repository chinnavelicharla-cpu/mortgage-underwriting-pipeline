
-- Extract mortgage application fields from the RAW JSON payload.

SELECT
    PAYLOAD:applicant_id::NUMBER AS APPLICANT_ID,
    PAYLOAD:applicant_name::VARCHAR AS APPLICANT_NAME,
    PAYLOAD:loan_amount::NUMBER(12,2) AS LOAN_AMOUNT,
    PAYLOAD:property_value::NUMBER(12,2) AS PROPERTY_VALUE,
    PAYLOAD:monthly_income::NUMBER(12,2) AS MONTHLY_INCOME,
    SOURCE_FILE,
    LOADED_AT
FROM {{ source('mortgage_raw', 'mortgage_applications_raw') }}
