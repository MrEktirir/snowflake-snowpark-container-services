-- ============================================================
-- Snowpark Container Services - Convert API + Service Function
-- ============================================================

USE ROLE CONTAINER_USER_ROLE;
USE DATABASE CONTAINER_HOL_DB;
USE SCHEMA PUBLIC;
USE WAREHOUSE CONTAINER_HOL_WH;

-- Deploy the Flask REST API on the existing compute pool
CREATE SERVICE IF NOT EXISTS CONVERT_API_SERVICE
    IN COMPUTE POOL CONTAINER_HOL_POOL
    FROM @SPECS
    SPECIFICATION_FILE = 'convert-api.yaml';

-- Verify the container runtime
SHOW SERVICE CONTAINERS IN SERVICE CONVERT_API_SERVICE;

CALL SYSTEM$GET_SERVICE_LOGS(
    'CONTAINER_HOL_DB.PUBLIC.CONVERT_API_SERVICE',
    '0',
    'convert-api',
    20
);

-- Sample dataset used to demonstrate calling the containerized API
CREATE OR REPLACE TABLE WEATHER (
    DATE DATE,
    LOCATION VARCHAR,
    TEMP_C NUMBER,
    TEMP_F NUMBER
);

INSERT INTO WEATHER (DATE, LOCATION, TEMP_C, TEMP_F)
VALUES
    ('2023-03-21', 'London', 15, NULL),
    ('2023-07-13', 'Manchester', 20, NULL),
    ('2023-05-09', 'Liverpool', 17, NULL),
    ('2023-09-17', 'Cambridge', 19, NULL),
    ('2023-11-02', 'Oxford', 13, NULL),
    ('2023-01-25', 'Birmingham', 11, NULL),
    ('2023-08-30', 'Newcastle', 21, NULL),
    ('2023-06-15', 'Bristol', 16, NULL),
    ('2023-04-07', 'Leeds', 18, NULL),
    ('2023-10-23', 'Southampton', 12, NULL);

-- Expose the SPCS REST endpoint as a Snowflake SQL function
CREATE OR REPLACE FUNCTION CONVERT_UDF(input FLOAT)
RETURNS FLOAT
SERVICE = CONVERT_API_SERVICE
ENDPOINT = 'convert-api'
MAX_BATCH_ROWS = 5
AS '/convert';

-- Single-value end-to-end test
SELECT CONVERT_UDF(12) AS CONVERSION_RESULT;

-- Execute the containerized conversion against table data
UPDATE WEATHER
SET TEMP_F = CONVERT_UDF(TEMP_C);

SELECT *
FROM WEATHER
ORDER BY DATE;
