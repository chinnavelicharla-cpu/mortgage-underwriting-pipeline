
-- Clean and standardize credit bureau source data.

SELECT
    APPLICANT_ID::NUMBER AS APPLICANT_ID,
    SSN::VARCHAR AS SSN,
    CREDIT_SCORE::NUMBER AS CREDIT_SCORE,
    MONTHLY_DEBT::NUMBER(12,2) AS MONTHLY_DEBT,
    SOURCE_FILE,
    LOADED_AT
FROM {{ source('mortgage_raw', 'credit_bureau_raw') }}
