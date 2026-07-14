# Microsoft-Fabric-Procurement-Project

End-to-end Data Engineering & Analytics solution built in Microsoft Fabric. Features Data Factory ingestion pipelines, a multi-tier Medallion Architecture (Bronze/Silver/Gold) via PySpark notebooks, Delta Lake, star-schema data modeling, and automated executive Power BI reporting.

---
**Business Problem**

Multinational manufacturing organisations operating across multiple countries and currencies face significant challenges in managing their Procure-to-Pay (P2P) process:

>>No single view of spend across vendors, plants and legal entities operating in different currencies

>>Manual reporting — procurement teams spending hours pulling data from disparate systems with no automated refresh

>>Delayed visibility — invoice issues and delivery failures identified too late to act on

>>No supplier performance tracking — no systematic way to measure which vendors deliver on time and within agreed terms

>>Currency inconsistency — POs raised in USD, EUR, GBP and INR making spend comparison impossible without normalisation

**Solution**

This project delivers an automated, end-to-end P2P Analytics Platform built on Microsoft Fabric that:

>>Consolidates procurement data from SQL Server and Azure Blob Storage into a single OneLake Lakehouse

>>Automates daily incremental data loads via metadata-driven Fabric Pipelines with full audit logging

>>Applies 25+ data quality transformations in PySpark across 5 fact tables and 8 dimension tables

>>Normalises all spend to GBP using live exchange rates enabling like-for-like comparison across 4 currencies

>>Delivers a Power BI Executive Dashboard with KPIs for procurement leadership updated on every pipeline run

**Business KPIs Delivered**

KPIBusiness Question Answered

>>Total Spend (GBP)---How much are we spending across all companies?

>>Open PO Count---How many orders are still outstanding?

>>Avg Days to Receive---How fast are our suppliers delivering?

>>Avg Days to Invoice---How efficient is our invoice processing?

>>Delivery Performance---Which suppliers consistently deliver on time?

>>Blocked Invoice %---Where are payment bottlenecks occurring?

>>Spend by Vendor---Who are our top suppliers by spend?

>>Spend by Material Type---What categories drive the most cost?

## Architecture

Medallion architecture (Bronze → Silver → Gold) built entirely in Microsoft Fabric, fed by two source systems using two different ingestion patterns:

- **Azure Blob Storage** (CSV and JSON source files) — connected via a **OneLake shortcut**, referencing the data directly without copying it into the lakehouse.
- **On-prem SQL Server** — loaded via **Fabric Data Pipelines**, using incremental loads with watermarking to only pull new/changed records on each run.

Both land in the **Bronze** layer, then flow through:

- **Bronze**: Raw ingestion from both source systems
- **Silver**: Cleansed, standardized dimension and fact tables (PySpark notebooks)
- **Gold**: Star-schema data model, ready for reporting
- **Semantic model**: Relationships defined between fact and dimensions for Power BI

![Architecture Diagram](Architecture/medallion_architecture.png)

## Tech Stack

- Microsoft Fabric (OneLake, Lakehouse, Data Pipelines)
- PySpark Notebooks
- Delta Lake
- Fabric SQL Database
- Azure Blob Storage
- Power BI

## Sample Data

The `/sample_data` folder contains synthetic source data matching the two real ingestion paths used in this project:

- [`Azure_Blob_Source/`](sample_data/Azure_Blob_Source) — master/reference (dimension) data, loaded via a OneLake shortcut
- [`SQL_Source/`](sample_data/SQL_Source) — transactional (fact) data, loaded via Fabric Data Pipelines

See [`sample_data/data_dictionary.md`](sample_data/data_dictionary.md) for full column definitions of every source file.
> Note: all vendor names, values, and identifiers are synthetically generated for demonstration purposes and do not represent any real organization's data. In the live pipeline, SQL_Source data is read directly from SQL Server via a database connection, not from files — the CSVs here are a static extract provided so the notebooks are runnable without a live database.


## Star Schema & Semantic Model

**Fact table:** `gold_fact_procurement`

**Dimension tables:** `gold_dim_vendor`, `gold_dim_material`, `gold_dim_plant`, `gold_dim_company`, `gold_dim_cost_center`, `gold_dim_currency`, `gold_dim_purchase_group`, `gold_dim_date`

One-to-many relationships are defined between the fact table and each dimension on its natural key (Vendor_ID, Material_ID, Plant_ID, Cost_Center_ID, Currency_Code, Purchasing_Group_ID, Date_Key), enabling correct cross-filtering across all report visuals without manual DAX joins.

![Star Schema and Semantic Model](Screenshots/Star_schema.png)

## Pipeline Overview

- Two distinct ingestion patterns: OneLake shortcut (Blob) and Data Pipelines (SQL Server)
- Incremental loading with watermarking for the SQL source
- Incremental loading is driven by a dedicated `Watermark_Procurement` table (tracking `Last_Modified_Date` per source table), with full run auditing in `Pipeline_Execution_History`. See [`SQL/orchestration_tables.sql`](SQL/orchestration_tables.sql) for the table definitions and load mechanism.
- `ForEach`-based dynamic ingestion across source tables
- Automated stored procedure execution for pipeline start/end logging
- Data quality validation notebook checking for duplicate records, referential integrity, and dimension completeness at the Gold layer
- Three-environment deployment: Dev → QA → Production

Transformation logic for each Bronze source table is documented in [`Notebooks/mapping_specification.md`](Notebooks/mapping_specification.md), specifying source data types, business rules, and the PySpark casting/validation logic applied per column.

### Ingestion pipeline
Uses a `Lookup` activity to fetch the list of source tables, then a `ForEach` loop dynamically executes stored procedures per table, with watermark tracking for incremental loads.

![Ingestion Pipeline](Screenshots/Pipeline_procurement_ingestion.png)

### Master orchestration pipeline
Chains the ingestion pipeline with the Bronze→Silver→Gold notebooks in sequence.

![Master Pipeline](Screenshots/master_pipeline.png)

## Deployment Pipeline

Three-stage deployment across isolated environments, promoting workspace items (notebooks, pipelines, semantic models, reports) from Development through to Production:

- **Development** — `WS_Procurement_DEV`
- **Test** — `WS_Procurement_QA`
- **Production** — `WS_Procurement_PROD`

Each stage is validated before promotion — deployments are tracked with timestamps and status, with the ability to compare stage items and review deployment history.

![Deployment Pipeline](Screenshots/deployment_pipeline.png)

## Dashboards & Reports

### Executive Report
![Executive Report](Screenshots/executive_report.png)

### Operations Report
![Operations Report](Screenshots/operations_report.png)

### Executive Dashboard
![Executive Dashboard](Screenshots/Procurement_executive_dashboard.png)

### Operations Dashboard
![Operations Dashboard](Screenshots/Procurement_dashboard.png)

## Repository Structure

- `/Notebooks` — PySpark notebooks (Bronze→Silver dimension/fact, Silver→Gold, Gold data quality checks) and the source-to-target mapping specification
- `/SQL` — Stored procedures and orchestration table definitions for pipeline processing and incremental loads
- `/Architecture` — Architecture diagrams
- `/Screenshots` — Dashboard, pipeline, and data model screenshots
- `/sample_data` — Synthetic sample source data, split by ingestion path (`Azure_Blob_Source` / `SQL_Source`), with a full data dictionary so the notebooks can be run end-to-end
  
## What This Project Demonstrates

- End-to-end data pipeline design in a modern lakehouse platform
- Correct use of OneLake shortcuts vs. data pipelines depending on source type
- Deliberate source-to-target mapping design, including data type decisions, business rule enforcement, and cross-field validation, ahead of implementation
- Dimensional modeling (star schema) with properly defined semantic model relationships
- Data quality validation, including root-cause diagnosis of referential integrity issues (orphaned fact records against dimension keys)
- Incremental load patterns using watermarking
- CI/CD-style release management using Fabric Deployment Pipelines across Dev, QA, and Production workspaces

## 👩‍💻 Author

**Vineetha Uppu**  
Data Engineer — Microsoft Fabric | SAP BODS | ETL & Data Migration

🔗 [LinkedIn](https://www.linkedin.com/in/vineetha-uppu-7b15b9334)  
🐙 [GitHub](https://github.com/uppuvinnetha2903)

