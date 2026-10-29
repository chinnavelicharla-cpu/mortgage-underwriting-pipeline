
-- Demonstration: mask sensitive strings for non-compliance roles.
-- Apply these policies to the appropriate columns after creating
-- the target table and granting the required privileges.

CREATE ROLE IF NOT EXISTS COMPLIANCE_ROLE;
CREATE ROLE IF NOT EXISTS ANALYST_ROLE;

CREATE OR REPLACE MASKING POLICY
    MORTGAGE_DB.RAW.PII_STRING_MASK
    AS (VAL VARCHAR)
    RETURNS VARCHAR ->
        CASE
            WHEN IS_ROLE_IN_SESSION('COMPLIANCE_ROLE')
                THEN VAL
            ELSE '***MASKED***'
        END;

-- Example: apply to a table column after the target table exists.
-- ALTER TABLE MORTGAGE_DB.SILVER.INT_MORTGAGE_APPLICATIONS
--     MODIFY COLUMN APPLICANT_NAME
--     SET MASKING POLICY MORTGAGE_DB.RAW.PII_STRING_MASK;

-- Apply the same policy to SSN after confirming its column type is VARCHAR.
