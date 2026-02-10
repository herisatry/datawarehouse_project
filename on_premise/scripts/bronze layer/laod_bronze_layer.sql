/*
author : Herisatry Lubaba
Purpose :
==========
this script will perform the raw data insertion in bulk instead of row by row (requirements of the project).
we will turn it into a procedure , that will stored in the bronze schema since it is related to the load of that schema.
we will add log messages and try to catch errors.

warning : make sure you are in the correct database.
*/


	/*
	=========================== CRM SYSTEM TABLES ====================================
	*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	-- create variable that will store the time at which a snippets of the script starts and ends, to get an estimate of the duration of the script run.
	DECLARE @start_time datetime, @end_time datetime, @batch_starttime datetime , @batch_endtime datetime
	BEGIN TRY
		SET @batch_starttime=GETDATE();
		SET @start_time=GETDATE();
		PRINT'>>> Starting operations on bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM '/var/opt/mssql/dataset/source_crm/cust_info.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK);
		SET @end_time=GETDATE();
		PRINT'>>> Operation Successfuly completed in: ' + CAST( DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) +' seconds'

		SET @start_time=GETDATE();
		PRINT'>>> Starting operations on bronze.crm_prod_info';
		TRUNCATE TABLE bronze.crm_prod_info;
		BULK INSERT bronze.crm_prod_info
		FROM '/var/opt/mssql/dataset/source_crm/prd_info.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK);
		SET @end_time=GETDATE();
		PRINT'>>> Operation Successfuly completed in: ' + CAST( DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) +' seconds'

		SET @start_time=GETDATE();
		PRINT'>>> Starting operations on bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM '/var/opt/mssql/dataset/source_crm/sales_details.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK);
		SET @end_time=GETDATE();
		PRINT'>>> Operation Successfuly completed in: ' + CAST( DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) +' seconds'

		/*
		=========================== ERP SYSTEM TABLES ====================================
		*/

		SET @start_time=GETDATE();
		PRINT'>>> Starting operations on bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM '/var/opt/mssql/dataset/source_erp/cust_az12.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK);
		SET @end_time=GETDATE();
		PRINT'>>> Operation Successfuly completed in: ' + CAST( DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) +' seconds'

		SET @start_time=GETDATE();
		PRINT'>>> Starting operations on bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM '/var/opt/mssql/dataset/source_erp/loc_a101.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK);
		SET @end_time=GETDATE();
		PRINT'>>> Operation Successfuly completed in: ' + CAST( DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) +' seconds'

		SET @start_time=GETDATE();
		PRINT'>>> Starting operations on bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM '/var/opt/mssql/dataset/source_erp/px_cat_g1v2.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK);
		SET @end_time=GETDATE();
		PRINT'>>> Operation Successfuly completed in: ' + CAST( DATEDIFF(second,@start_time , @end_time) AS NVARCHAR) +' seconds'
		SET @batch_endtime=GETDATE();
		PRINT'>>> Batch Operation Successfuly completed in: ' + CAST( DATEDIFF(second,@batch_starttime , @batch_endtime) AS NVARCHAR) +' seconds';
	END TRY
	BEGIN CATCH
	-- in case of error , let's show a custom message and log it.
	PRINT'An error occured while executing the procedure : '+ ERROR_MESSAGE();
	PRINT'Error Number : '+ CAST(ERROR_NUMBER() AS NVARCHAR);
	END CATCH;
END;