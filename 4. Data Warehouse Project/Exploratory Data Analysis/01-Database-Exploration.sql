/* =========================================================
   Script Purpose: Database Exploration
   =========================================================
   This script provides quick metadata exploration to help
   understand the structure of the database.

   What it does:
   1) Lists all tables/views available in the database using
      INFORMATION_SCHEMA.TABLES (object inventory).
   2) Lists all columns for a specific object (dim_customers)
      using INFORMATION_SCHEMA.COLUMNS, including column names,
      data types, nullability, and related attributes.

   Typical use cases:
   - Confirm which objects exist in each schema (bronze/silver/gold)
   - Inspect table/view structure before writing joins or ETL
   - Validate column names and data types when debugging queries
   ========================================================= */

-- Explore ALL Objects in the Database
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- Explore ALL Columns in the Database (for dim_customers)
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
