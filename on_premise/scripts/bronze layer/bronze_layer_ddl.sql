/*
AUTHOR : Herisatry Aky
PURPOSE :
========
create tables for the BRONZE LAYER (DDL) for all the csv in the dataset.
the script will check if the table exist inside the schema if it is not existing then we will create it.
*/
USE datawarehouse_db;

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='crm_cust_info' and TABLE_SCHEMA='bronze')
DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(2),
cst_gndr NVARCHAR(2),
cst_create_date DATE
);

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='crm_prod_info' and TABLE_SCHEMA='bronze')
DROP TABLE bronze.crm_prod_info;
CREATE TABLE bronze.crm_prod_info (
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE
);

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='crm_sales_details' and TABLE_SCHEMA='bronze')
DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='erp_cust_az12' and TABLE_SCHEMA='bronze')
DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
cid NVARCHAR(50),
bdate DATE,
gen NVARCHAR(50)
);

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='erp_loc_a101' and TABLE_SCHEMA='bronze')
DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
cid NVARCHAR(50),
cntry NVARCHAR(50)
);

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='erp_px_cat_g1v2' and TABLE_SCHEMA='bronze')
DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintenance NVARCHAR(50)
);