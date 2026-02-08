/* ============================================================
   Data Warehouse Environment Setup (SQL Server)
   ------------------------------------------------------------
   Purpose:
   - Create the main DataWarehouse database.
   - Create logical "layers" for a medallion architecture:
     Bronze  = raw/landing data
     Silver  = cleaned/standardized data
     Gold    = curated/business-ready data


   ============================================================ */

USE master;
CREATE DATABASE DataWarehouse;
USE DataWarehouse;
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
