-- ============================================================
-- Snowpark Container Services - Container Infrastructure
-- ============================================================

USE ROLE CONTAINER_USER_ROLE;
USE DATABASE CONTAINER_HOL_DB;
USE SCHEMA PUBLIC;

-- Compute resources used to run containerized services
CREATE COMPUTE POOL IF NOT EXISTS CONTAINER_HOL_POOL
    MIN_NODES = 1
    MAX_NODES = 1
    INSTANCE_FAMILY = CPU_X64_XS;

-- Registry for Docker/OCI images used by SPCS services
CREATE IMAGE REPOSITORY IF NOT EXISTS IMAGE_REPO;

SHOW IMAGE REPOSITORIES IN SCHEMA CONTAINER_HOL_DB.PUBLIC;

/*
External Access Integration
---------------------------
The original tutorial configures an External Access Integration to
allow outbound Internet access from containers.

This project was implemented on a Snowflake trial account where
External Access Integration was not supported. The Jupyter and
Convert API services do not require outbound Internet access for
the demonstrated workflow because their dependencies are packaged
inside their container images.

The external access setup was therefore intentionally omitted.
*/
