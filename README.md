# Data Warehouse Project

A SQL Server-based Data Warehouse implementing the medallion architecture to consolidate sales data from CRM and ERP systems for analytical reporting and decision-making.

## Project Objectives

- Import and consolidate data from two source systems (ERP and CRM)
- Cleanse and resolve data quality issues
- Create a user-friendly data model for analytical queries
- Deliver insights into Customer Behavior, Product Performance, and Sales Trends

## Architecture

### Medallion Layers

The data warehouse uses three schema layers in `datawarehouse_db`:

| Layer | Schema | Purpose | Users |
|-------|--------|---------|-------|
| Bronze | `bronze` | Raw data ingested from source CSV files | Data Engineers |
| Silver | `silver` | Cleaned and enriched data | Data Analysts, Data Engineers |
| Gold | `gold` | Aggregated business-quality data | Data Analysts, Data Scientists |

### Data Sources

**CRM System** (`dataset/source_crm/`):
- `cust_info.csv` - Customer information
- `prd_info.csv` - Product information  
- `sales_details.csv` - Sales transactions

**ERP System** (`dataset/source_erp/`):
- `CUST_AZ12.csv` - Customer demographics
- `LOC_A101.csv` - Customer locations
- `PX_CAT_G1V2.csv` - Product categories

## Project Structure

```
DWH_PROJ/
+-- dataset/                    # Source CSV files
    +-- source_crm/            # CRM system exports
    +-- source_erp/            # ERP system exports
+-- on_premise/                 # On-premise SQL Server implementation
    +-- docs/                  # Requirements documentation
    +-- scripts/               # SQL scripts
        +-- init.sql          # Database and schema creation
        +-- bronze layer/     # Bronze layer scripts
    +-- test/                  # Test scripts
+-- cloud_based/               # Cloud implementation (future)
+-- sqlserver-docker/          # Docker setup for local development
    +-- docker-compose.yml    # SQL Server container config
    +-- backups/              # Database backup storage
    +-- scripts/              # Container initialization scripts
+-- docs/                      # Project documentation
```

## Getting Started

### Prerequisites

- Docker and Docker Compose
- SQL Server client (SSMS, Azure Data Studio, or sqlcmd)

### 1. Start SQL Server

```powershell
docker-compose -f sqlserver-docker/docker-compose.yml up -d
```

**Connection Details:**
- Host: `localhost`
- Port: `1433`
- User: `sa`
- Password: `StrongPassword123!`

### 2. Initialize Database

Run the SQL scripts in order:

```sql
-- 1. Create database and schemas
-- Run: on_premise/scripts/init.sql

-- 2. Create bronze layer tables
-- Run: on_premise/scripts/bronze layer/bronze_layer_ddl.sql

-- 3. Create load procedure
-- Run: on_premise/scripts/bronze layer/laod_bronze_layer.sql

-- 4. Execute data load
-- Run: on_premise/scripts/bronze layer/proc_exec_bronze.sql
```

The dataset folder is automatically mounted to `/var/opt/mssql/dataset` in the container for BULK INSERT operations.

## Development Guidelines

### SQL Script Conventions

- Include a header comment block with author and purpose
- Use `USE datawarehouse_db;` at the start of scripts
- Check object existence before CREATE/DROP operations
- Include TRY/CATCH error handling with timing logs in procedures
- Table naming convention: `{source}_{entity}` (e.g., `crm_cust_info`, `erp_loc_a101`)

### Bronze Layer Development Steps

1. **Analyze the source data:**
   - Identify the system source and data owner
   - Review available documentation and data catalogs

2. **Data architecture:**
   - Determine storage location (SQL Server, AWS, Azure, GCP)
   - Assess integration capabilities (API, file extraction)

3. **Extraction and load:**
   - Decide on incremental vs full loads
   - Define data scope and historical requirements
   - Estimate data volume
   - Configure authentication and authorization
