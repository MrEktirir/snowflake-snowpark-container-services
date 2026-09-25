-- ============================================================
-- Snowpark Container Services - Jupyter Service
-- ============================================================

USE ROLE CONTAINER_USER_ROLE;
USE DATABASE CONTAINER_HOL_DB;
USE SCHEMA PUBLIC;
USE WAREHOUSE CONTAINER_HOL_WH;

CREATE SERVICE IF NOT EXISTS JUPYTER_SNOWPARK_SERVICE
    IN COMPUTE POOL CONTAINER_HOL_POOL
    FROM @SPECS
    SPECIFICATION_FILE = 'jupyter-snowpark.yaml';

-- Verify container state and runtime logs
SHOW SERVICE CONTAINERS IN SERVICE JUPYTER_SNOWPARK_SERVICE;

CALL SYSTEM$GET_SERVICE_LOGS(
    'CONTAINER_HOL_DB.PUBLIC.JUPYTER_SNOWPARK_SERVICE',
    '0',
    'jupyter-snowpark',
    20
);

-- Display the public Jupyter endpoint
SHOW ENDPOINTS IN SERVICE JUPYTER_SNOWPARK_SERVICE;
