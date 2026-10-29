
-- Load credit bureau CSV data into Snowflake RAW.

-- Create a stage for the credit bureau CSV.
CREATE STAGE IF NOT EXISTS MORTGAGE_DB.RAW.CREDIT_CSV_STAGE
    FILE_FORMAT = MORTGAGE_DB.RAW.CREDIT_CSV_FORMAT;

-- Load CSV records into the RAW credit bureau table.
COPY INTO MORTGAGE_DB.RAW.CREDIT_BUREAU_RAW
    (
        APPLICANT_ID,
        SSN,
        CREDIT_SCORE,
        MONTHLY_DEBT,
        SOURCE_FILE
    )
FROM (
    SELECT
        $1::NUMBER,
        $2::VARCHAR,
        $3::NUMBER,
        $4::NUMBER(12,2),
        METADATA$FILENAME
    FROM @MORTGAGE_DB.RAW.CREDIT_CSV_STAGE
)
FILE_FORMAT = (
    FORMAT_NAME = 'MORTGAGE_DB.RAW.CREDIT_CSV_FORMAT'
)
ON_ERROR = 'ABORT_STATEMENT';
