# Microsoft-Fabric-Procurement-Project
End-to-end Data Engineering Analytics solution built in Microsoft Fabric. Features Data Factory ingestion pipelines, a multi-tier Medallion Architecture (Bronze/Silver/Gold) via PySpark Notebooks,Delta Lake, star-schema data modeling, and Power BI.

## Architecture
Medallion architecture (Bronze → Silver → Gold) built entirely in Microsoft Fabric:
- **Bronze**: Raw ingestion via Data Factory pipelines
- **Silver**: Cleansed, conformed dimension and fact tables (PySpark notebooks)
- **Gold**: Star-schema data model ready for reporting

![Architecture Diagram](Architecture/medallion_architecture.png)

## Tech Stack
- Microsoft Fabric (OneLake, Lakehouse, Data Pipelines)
- PySpark Notebooks
- Delta Lake
- Fabric SQL Database
- Azure Blob
- SQL
- Power BI

## Star Schema Data Model
Fact tables: fact_purchase_order, fact_goods_receipt, fact_invoice_receipt
Dimensions: dim_vendor, dim_material, dim_plant, dim_cost_center, dim_purchasing_group, dim_company, dim_date

[Data Model](Screenshots/star_schema.png)

## Pipeline Overview
- Incremental loading with watermarking
- ForEach-based dynamic ingestion across source tables
- Automated stored procedure execution (start/end logging)
- Three-environment deployment: Dev → QA → Prod

[Pipeline](Screenshots/master_pipeline.png)

## Dashboards & Reports
### Executive Report
[Executive Report](Screenshots/executive_report.png)

### Operations Report
[Operations Report](Screenshots/operations_report.png)

## Repository Structure
- `/Notebooks` – PySpark notebooks (Bronze→Silver, Silver→Gold, data quality checks)
- `/SQL` – Stored procedures for pipeline orchestration
- `/Architecture` – Architecture diagrams
- `/Screenshots` – Dashboard and model screenshots

## What This Project Demonstrates
- End-to-end data pipeline design in a modern lakehouse platform
- Dimensional modeling (star schema) for analytics
- Data quality validation and incremental load patterns
- Multi-environment CI/CD-style deployment (Dev/QA/Prod)
