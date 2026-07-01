# Microsoft-Fabric-Procurement-Project

End-to-end Data Engineering & Analytics solution built in Microsoft Fabric. Features Data Factory ingestion pipelines, a multi-tier Medallion Architecture (Bronze/Silver/Gold) via PySpark notebooks, Delta Lake, star-schema data modeling, and automated executive Power BI reporting.

## Architecture

Medallion architecture (Bronze → Silver → Gold) built entirely in Microsoft Fabric, fed by two source systems using two different ingestion patterns:

- **Azure Blob Storage** — connected via a **OneLake shortcut**, referencing the data directly without copying it into the lakehouse.
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

## Star Schema Data Model

**Fact table:** `gold_fact_procurement`

**Dimension tables:** `gold_dim_vendor`, `gold_dim_material`, `gold_dim_plant`, `gold_dim_company`, `gold_dim_cost_center`, `gold_dim_currency`, `gold_dim_purchase_group`, `gold_dim_date`

![Data Model](Screenshots/star_schema.png)

## Semantic Model & Relationships

Built the Power BI semantic model directly on top of the Gold layer, defining one-to-many relationships between `gold_fact_procurement` and each dimension table:

- `gold_dim_vendor` (Vendor_ID)
- `gold_dim_material` (Material_ID)
- `gold_dim_plant` (Plant_ID)
- `gold_dim_company` (Company_Code)
- `gold_dim_cost_center` (Cost_Center_ID)
- `gold_dim_currency` (Currency_Code)
- `gold_dim_purchase_group` (Purchasing_Group_ID)
- `gold_dim_date` (Date_Key)

This enables cross-filtering across all report visuals — filtering by vendor, plant, or date automatically slices the fact table correctly, without needing manual DAX joins in every measure.

![Semantic Model](Screenshots/semantic_model.png)

## Pipeline Overview

- Two distinct ingestion patterns: OneLake shortcut (Blob) and Data Pipelines (SQL Server)
- Incremental loading with watermarking for the SQL source
- `ForEach`-based dynamic ingestion across source tables
- Automated stored procedure execution for pipeline start/end logging
- Data quality validation notebook checking for duplicate records, referential integrity, and dimension completeness at the Gold layer
- Three-environment deployment: Dev → QA → Production

![Pipeline](Screenshots/master_pipeline.png)

## Dashboards & Reports

### Executive Report
![Executive Report](Screenshots/executive_report.png)

### Operations Report
![Operations Report](Screenshots/operations_report.png)

## Repository Structure

- `/Notebooks` — PySpark notebooks (Bronze→Silver dimension/fact, Silver→Gold, Gold data quality checks)
- `/SQL` — Stored procedures for pipeline orchestration
- `/Architecture` — Architecture diagrams
- `/Screenshots` — Dashboard, pipeline, and data model screenshots

## What This Project Demonstrates

- End-to-end data pipeline design in a modern lakehouse platform
- Correct use of OneLake shortcuts vs. data pipelines depending on source type
- Dimensional modeling (star schema) with properly defined semantic model relationships
- Data quality validation, including root-cause diagnosis of referential integrity issues (orphaned fact records against dimension keys)
- Incremental load patterns using watermarking
- Multi-environment deployment (Dev → QA → Production)
