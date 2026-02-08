/* ============================================================
   Data Warehouse Environment Setup (MySQL)
   ------------------------------------------------------------
   Purpose:
   - Create the main DataWarehouse database.
   - Create logical "layers" for a medallion architecture:
     Bronze  = raw/landing data
     Silver  = cleaned/standardized data
     Gold    = curated/business-ready data

   Important (MySQL behavior):
   - In MySQL, SCHEMA is a synonym for DATABASE.
   - So Bronze/Silver/Gold will be created as separate databases,
     not schemas nested inside DataWarehouse.

   ============================================================ */

-- 1) Create the main database (container for general DW objects)
CREATE DATABASE IF NOT EXISTS DataWarehouse;

-- 2) Set the active database context
USE DataWarehouse;

-- 3) Create medallion layers (as separate databases in MySQL)
CREATE DATABASE IF NOT EXISTS bronze;
CREATE DATABASE IF NOT EXISTS silver;
CREATE DATABASE IF NOT EXISTS gold;
