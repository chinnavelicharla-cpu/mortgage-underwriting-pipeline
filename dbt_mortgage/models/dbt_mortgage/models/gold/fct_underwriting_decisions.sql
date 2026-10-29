
-- Calculate underwriting metrics and generate lending decisions.

WITH valid_applications AS (

    SELECT *
    FROM {{ ref('int_mortgage_applications') }}
    WHERE TECHNICAL_REJECTION_REASON IS NULL

),

underwriting_metrics AS (

    SELECT
        APPLICANT_ID,
        APPLICANT_NAME,
        LOAN_AMOUNT,
        PROPERTY_VALUE,
        MONTHLY_INCOME,
        CREDIT_SCORE,
        MONTHLY_DEBT,
        SSN,

        ROUND(
            LOAN_AMOUNT / NULLIF(PROPERTY_VALUE, 0) * 100,
            2
        ) AS LTV_PERCENT,

        ROUND(
            MONTHLY_DEBT / NULLIF(MONTHLY_INCOME, 0) * 100,
            2
        ) AS DTI_PERCENT

    FROM valid_applications

),

decisions AS (

    SELECT
        *,
        CASE
            WHEN LTV_PERCENT > 95
                THEN 'DECLINED'
            WHEN DTI_PERCENT > 43
                THEN 'DECLINED'
            WHEN CREDIT_SCORE < 620
                THEN 'DECLINED'
            WHEN CREDIT_SCORE BETWEEN 620 AND 660
                 AND DTI_PERCENT BETWEEN 36 AND 43
                THEN 'REQUIRES_COSIGNER'
            ELSE 'APPROVED'
        END AS DECISION_STATUS,

        CASE
            WHEN LTV_PERCENT > 95
                THEN 'DECLINED_LTV_EXCEEDED'
            WHEN DTI_PERCENT > 43
                THEN 'DECLINED_DTI_EXCEEDED'
            WHEN CREDIT_SCORE < 620
                THEN 'DECLINED_FICO_TOO_LOW'
            WHEN CREDIT_SCORE BETWEEN 620 AND 660
                 AND DTI_PERCENT BETWEEN 36 AND 43
                THEN 'COSIGNER_REQUIRED'
            ELSE 'APPROVED'
        END AS DECISION_REASON

    FROM underwriting_metrics

)

SELECT
    *,
    CURRENT_TIMESTAMP() AS DECISION_TIMESTAMP
FROM decisions
