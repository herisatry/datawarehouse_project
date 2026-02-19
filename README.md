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


Building on the Silver Layer, here is the breakdown for the **Bronze** and **Gold** layers to complete your ETL pipeline documentation. This follow-up uses the same "What, Why, How" structure to keep your technical records consistent and easy for beginners to follow.

---

## Bronze Layer (Raw Data)

### What?

The Bronze Layer is the landing zone where data arrives in its original, raw format directly from source systems (like APIs, SQL databases, or IoT sensors).

### Why?

It acts as a historical archive. By saving data exactly as it was received, you ensure that if a mistake happens during transformation, you can always go back to the original "source of truth" and re-process it without losing information.

### How?

Data is ingested using **Incremental Loads** or **Append-only** methods. Very little logic is applied here; the focus is on speed and capturing every detail, including timestamps and source metadata.

---

## Silver Layer Documentation


### What?

The Silver Layer is an intermediate data storage tier that houses cleaned, standardized, and enriched data. It takes raw records from the Bronze layer and transforms them into structured tables that are ready for advanced analysis and modeling.

---

### Why?

Raw data is often inconsistent or contains errors. The Silver Layer ensures that everyone in the organization is working with a "single version of truth." By performing cleaning and normalization here, you reduce the workload for data analysts and prevent redundant processing later in the pipeline.

---

### How?

**1. Data Refinement & Enrichment**
The pipeline applies several transformation logic steps to ensure quality:

* **Cleaning:** Removing null values, duplicates, and fixing formatting errors.
* **Standardization:** Ensuring dates, currencies, and units follow a consistent format.
* **Normalization:** Organizing data to reduce redundancy and improve integrity.
* **Derived Columns:** Creating new metrics or calculated fields based on existing data.
* **Enrichment:** Adding context by joining disparate datasets together.

**2. Storage & Loading Strategy**
Data is stored in structured **Tables** rather than flat files. The loading method used is a **Full Load (Truncate & Insert)**. This means the existing table is wiped clean and replaced with the fresh, transformed dataset during every run to ensure no stale data remains.

**3. Accessibility**
The data is preserved in a refined state but remains relatively close to its original source structure (**as-is**). This allows **Data Engineers** to maintain the pipeline and **Data Analysts** to build specialized reports or move the data into the Gold layer for business-specific use cases.

---

## Gold Layer (Business-Ready)

### What?

The Gold Layer consists of high-level, aggregated datasets organized into "Data Marts." This data is usually structured in Star Schemas (Fact and Dimension tables) optimized for reporting.

### Why?

While Silver is for analysts, Gold is for the business. It provides lightning-fast performance for dashboards (like Power BI or Tableau) and ensures that key metrics, like "Monthly Revenue," are calculated identically across the entire company.

### How?

Data from the Silver layer is further refined through:

* **Aggregations:** Summing up daily sales into monthly totals.
* **Business Logic:** Applying specific rules, such as filtering out test accounts or applying tax calculations.
* **Join Logic:** Connecting different Silver tables to create a comprehensive view of a business process (e.g., Customer + Product + Sales).

---

### Comparison Summary

| Layer | Quality | Purpose | Main Users |
| --- | --- | --- | --- |
| **Bronze** | Raw / Dirty | Data Retention | Data Engineers |
| **Silver** | Clean / Validated | Integration & Research | Data Analysts |
| **Gold** | Aggregated / Final | Business Intelligence | Decision Makers |


Since your Bronze layer contains specific audit metadata that doesn't exist in the source system, the Silver layer DDL needs to inherit these fields to maintain full lineage.

## Metadata & Audit Columns

When moving from Bronze to Silver, we preserve the metadata added by Data Engineers. These columns are essential for tracking the data's journey through the pipeline.

### Silver Layer Schema Additions

The Silver Layer DDL mirrors the Bronze schema but includes a transformation on the audit logic:

* **create_date:** Records the initial load timestamp. In Silver, this represents when the record was first cleaned and standardized.
* **update_date:** Captures the last update timestamp. For a **Full Load (Truncate & Insert)**, this often matches the `create_date`.
* **source_system:** Identifies the origin system of the record (e.g., SAP, Salesforce, IoT Hub).
* **file_location:** Stores the path to the original source file, allowing engineers to trace errors back to the specific raw file.
* **dwh_create_date:** The final "Data Warehouse" timestamp added during the Silver DDL process to mark the completion of the transformation.

---

### Implementation Strategy

Because you are performing a **Full Load (Truncate & Insert)**, the Silver DDL ensures that every time the table is wiped, these metadata fields are recalculated to reflect the most recent successful run.
