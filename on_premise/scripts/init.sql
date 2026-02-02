/*
==================================
CREATE DATABASE AND SCHEMAS
==================================

Script purpose :
==============
this script initialize the whole project by creating the database "datawarehouse",
and the schemas that follows the architecture of our datawarehouse :
- bronze layer
- silver layer
- gold layer

Warning :
=========
*/

use master;
GO

IF NOT EXISTS (select name from sys.databases where name ='datawarehouse_db')
BEGIN
	-- creation of the new db
	CREATE DATABASE datawarehouse_db;
END;
GO
-- change to the newly create db
USE datawarehouse_db;
GO
-- we will create a schema for each layer.think of it as folders to keep things organized.
-- the next operations performs a check on the schemas before creating them.

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');  -- this schema will contain the raw data (Data Engineer only).
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver') -- this one will contain the cleaned data, enriched data (DA and DE)
    EXEC('CREATE SCHEMA silver');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
    EXEC('CREATE SCHEMA gold'); -- this one will contain the business quality data , aggregated data for consumers (data analyst , scientist ).
GO