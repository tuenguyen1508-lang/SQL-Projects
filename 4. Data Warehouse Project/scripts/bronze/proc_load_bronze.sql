/* =========================================================
   Script Purpose
   =========================================================
   This script creates (or updates) the stored procedure
   [bronze].[load_bronze] to load raw source files into the
   Bronze layer of the Data Warehouse.

   What it does:
   - Loads CRM and ERP source CSV files into Bronze tables
   - Truncates each target table before loading (full refresh)
   - Uses BULK INSERT for fast file ingestion
   - Logs load progress + duration for each table
   - Captures and prints error details if the load fails

   Target tables:
   - bronze.crm_cust_info
   - bronze.crm_prd_info
   - bronze.crm_sales_details
   - bronze.erp_cust_az12
   - bronze.erp_loc_a101
   - bronze.erp_px_cat_g1v2

Usage Example:
    EXEC bronze.load_silver;
   ========================================================= */
CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE
        @start_time       DATETIME,
        @end_time         DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time   DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '========================================';
        PRINT 'Loading Bronze Layer';
        PRINT '========================================';

        PRINT '----------------------------------------';
        PRINT 'Loading CRM tables';
        PRINT '----------------------------------------';

        /* ---------------------------
           bronze.crm_cust_info
        ----------------------------*/
        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting data into table: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\NGOCNT\Documents\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------------------------------------';

        /* ---------------------------
           bronze.crm_prd_info
        ----------------------------*/
        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting data into table: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\NGOCNT\Documents\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------------------------------------';

        /* ---------------------------
           bronze.crm_sales_details
        ----------------------------*/
        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting data into table: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\NGOCNT\Documents\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------------------------------------';

        PRINT '----------------------------------------';
        PRINT 'Loading ERP tables';
        PRINT '----------------------------------------';

        /* ---------------------------
           bronze.erp_cust_az12
        ----------------------------*/
        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting data into table: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\NGOCNT\Documents\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------------------------------------';

        /* ---------------------------
           bronze.erp_loc_a101
        ----------------------------*/
        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting data into table: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\NGOCNT\Documents\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------------------------------------';

        /* ---------------------------
           bronze.erp_px_cat_g1v2
        ----------------------------*/
        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting data into table: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\NGOCNT\Documents\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------------------------------------';

        SET @batch_end_time = GETDATE();

        PRINT '===============================';
        PRINT 'Loading Bronze Layer is completed';
        PRINT '>>>>> Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '===============================';
    END TRY
    BEGIN CATCH
        PRINT '===============================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
        PRINT 'Error message: ' + ERROR_MESSAGE();
        PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error state: '  + CAST(ERROR_STATE()  AS NVARCHAR);
        PRINT '===============================';
    END CATCH
END;
