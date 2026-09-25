-- ============================================================
-- Snowpark Container Services - Cleanup
-- ============================================================

USE ROLE CONTAINER_USER_ROLE;
USE DATABASE CONTAINER_HOL_DB;
USE SCHEMA PUBLIC;

-- Remove application services first
DROP SERVICE IF EXISTS JUPYTER_SNOWPARK_SERVICE;
DROP SERVICE IF EXISTS CONVERT_API_SERVICE;

-- Stop and remove container compute
ALTER COMPUTE POOL CONTAINER_HOL_POOL STOP ALL;
ALTER COMPUTE POOL CONTAINER_HOL_POOL SUSPEND;
DROP COMPUTE POOL IF EXISTS CONTAINER_HOL_POOL;

-- Remove project-level Snowflake resources
DROP WAREHOUSE IF EXISTS CONTAINER_HOL_WH;
DROP DATABASE IF EXISTS CONTAINER_HOL_DB;

-- Remove the project role
USE ROLE ACCOUNTADMIN;
DROP ROLE IF EXISTS CONTAINER_USER_ROLE;
