# Data Dictionary

This folder contains **synthetic sample data** used to build and test the Bronze → Silver → Gold pipeline in this project. All vendor names, plant names, cost centers, and values are fictional/generated and do not represent any real organization's data.

Structure mirrors the two source ingestion paths described in the main README:
- `dimensions/` — master/reference data (loaded via OneLake shortcut, representing the Azure Blob Storage source)
- `facts/` — transactional data (loaded via Fabric Data Pipelines, representing the on-prem SQL Server source)

---

## dimensions/

### vendor_master.csv
| Column | Type | Description |
|---|---|---|
| Vendor_ID | string | Unique vendor identifier |
| Vendor_Name | string | Vendor display name |
| Country_Code | string | ISO country code |
| City | string | Vendor city |
| Payment_Terms | string | e.g. NET30, NET45 |
| Vendor_Account_Group | string | DOMESTIC / INTERNATIONAL classification |
| Vendor_Status | string | Active / Inactive |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |

### material_master.csv
| Column | Type | Description |
|---|---|---|
| Material_ID | string | Unique material identifier |
| Material_Name | string | Material display name |
| Material_Type | string | e.g. ROH (raw materials), FERT (finished goods) |
| Material_Group | string | Material category |
| Unit_Of_Measure | string | e.g. BOX, KG |
| Material_Status | string | Active / Inactive |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |

### cost_center_master.csv
| Column | Type | Description |
|---|---|---|
| Cost_Center_ID | string | Unique cost center identifier |
| Cost_Center_Name | string | Cost center display name |
| Department | string | Owning department |
| Manager | string | Cost center manager |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |

### date_dimension.csv
| Column | Type | Description |
|---|---|---|
| Date_Key | int | Surrogate date key (YYYYMMDD) |
| Date | date | Calendar date |
| Year | int | Calendar year |
| Quarter | string | Q1–Q4 |
| Month | int | Month number |
| Month_Name | string | Month name |
| Day | int | Day of month |
| Weekday_Name | string | Day of week |

### plant_master.json
| Field | Type | Description |
|---|---|---|
| Plant_ID | string | Unique plant identifier |
| Plant_Name | string | Plant display name |
| Company_Code | string | Owning company |
| Country | string | ISO country code |
| Region | string | Regional grouping |
| City | string | Plant city |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |

### purchasing_group.json
| Field | Type | Description |
|---|---|---|
| Purchasing_Group_ID | string | Unique purchasing group identifier |
| Purchasing_Group_Name | string | Purchasing group display name |
| Department | string | Owning department/category |
| Manager | string | Purchasing group manager |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |

### company_master.json
| Field | Type | Description |
|---|---|---|
| Company_Code | string | Unique company identifier |
| Company_Name | string | Company display name |
| Country | string | ISO country code |
| Currency | string | Company's base currency |
| Region | string | Regional grouping |
| Industry | string | Industry classification |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |

### currency_exchange.json
| Field | Type | Description |
|---|---|---|
| Currency_Code | string | ISO currency code |
| Currency_Name | string | Currency display name |
| Exchange_Rate_To_GBP | decimal | Exchange rate used for GBP conversion in the Gold layer |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |

---

## facts/

### purchase_order_header.csv
| Column | Type | Description |
|---|---|---|
| PO_Number | string | Unique purchase order number |
| Company_Code | string | Purchasing company |
| PO_Document_Type | string | e.g. UB, ZCAP, FO, NB |
| PO_Date | date | Order creation date |
| Vendor_ID | string | Vendor fulfilling the order |
| Purchasing_Org | string | Purchasing organization code |
| Purchasing_Group_ID | string | Purchasing group responsible |
| Currency_Code | string | Order currency |
| PO_Status | string | e.g. OPEN, APPROVED, CANCELLED, CLOSED |
| PO_Last_Changed_Date | date | Last status change date |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |

### purchase_order_items.csv
| Column | Type | Description |
|---|---|---|
| PO_Number | string | Links to purchase_order_header |
| PO_Line_Item | int | Line item number within the PO |
| Material_ID | string | Material ordered |
| Plant_ID | string | Receiving plant |
| Storage_Location | string | Storage location code |
| Item_Category | string | Item category code |
| Order_Quantity | decimal | Quantity ordered |
| Unit_Of_Measure | string | e.g. BOX, KG |
| Net_Price | decimal | Price per unit |
| Net_Order_Value | decimal | Order_Quantity × Net_Price |
| Item_Status | string | e.g. INVOICED, PARTIAL, OPEN |
| PO_Line_Last_Changed_Date | date | Last line-level change date |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |

### account_assignment.csv
| Column | Type | Description |
|---|---|---|
| PO_Number | string | Links to purchase_order_header |
| PO_Line_Item | int | Links to purchase_order_items |
| Account_Assignment_Category | string | e.g. K (cost center), F (order) |
| Cost_Center_ID | string | Cost center charged |
| GL_Account | string | General ledger account |
| Internal_Order_ID | string | Internal order reference |
| WBS_Element | string | Project/WBS reference |
| Account_Assignment_Amount | decimal | Amount assigned |
| Currency_Code | string | Currency of the amount |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |

### goods_receipt.csv
| Column | Type | Description |
|---|---|---|
| Material_Doc_Number | string | Goods receipt document number |
| Material_Doc_Year | int | Document fiscal year |
| PO_Number | string | Links to purchase_order_header |
| PO_Line_Item | int | Links to purchase_order_items |
| Material_ID | string | Material received |
| Plant_ID | string | Receiving plant |
| Received_Quantity | decimal | Quantity received |
| Unit_Of_Measure | string | e.g. BOX, KG |
| Movement_Type | string | Goods movement type code |
| Posting_Date | date | Goods receipt posting date |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |

### invoice_items.csv
| Column | Type | Description |
|---|---|---|
| Invoice_Doc_Number | string | Invoice document number |
| Fiscal_Year | int | Invoice fiscal year |
| PO_Number | string | Links to purchase_order_header |
| PO_Line_Item | int | Links to purchase_order_items |
| Material_ID | string | Material invoiced |
| Invoiced_Quantity | decimal | Quantity invoiced |
| Invoice_Amount | decimal | Invoice amount |
| Invoice_Status | string | Posted / Blocked |
| Posting_Date | date | Invoice posting date |
| Created_Date | date | Record creation date |
| Last_Modified_Date | date | Watermark date for incremental load |
