# Source-to-Target Mapping Specification

Documents the column-level data type conversions, business rules, and PySpark transformations applied when moving each source table from **Bronze** to **Silver**.

## Purchase Order Header
**Target table:** `SILVER_purchase_order_header`

| Source Column | Source Data Type | Business Rule | Target Spark Type | Transformation Applied |
|---|---|---|---|---|
| `PO_Number` | int | — | `string` | Cast PO_Number to string to preserve leading zeros / business codes |
| `Company_Code` | int | — | `string` | Cast Company_Code to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `PO_Document_Type` | String | Make upper letters | `string` | Cast PO_Document_Type to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `PO_Date` | Date | — | `date` | Convert PO_Date to date using to_date() |
| `Vendor_ID` | int | — | `string` | Cast Vendor_ID to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Purchasing_Org` | String(alpha numeric) | Make upper letters | `string` | Cast Purchasing_Org to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Purchasing_Group_ID` | int | — | `string` | Cast Purchasing_Group_ID to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Currency_Code` | String | Make upper letters | `string` | Cast Currency_Code to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `PO_Status` | String | Make 1st letter upper | `string` | Cast PO_Status to string; trim spaces and convert to Proper Case using initcap(lower()) |
| `PO_Last_Changed_Date` | Date | — | `date` | Convert PO_Last_Changed_Date to date using to_date() |
| `Created_Date` | Date | — | `date` | Convert Created_Date to date using to_date() |
| `Last_Modified_Date` | Date | — | `date` | Convert Last_Modified_Date to date using to_date() |

## Items
**Target table:** `SILVER_purchase_order_items`

| Source Column | Source Data Type | Business Rule | Target Spark Type | Transformation Applied |
|---|---|---|---|---|
| `PO_Number` | int | — | `string` | Cast PO_Number to string to preserve leading zeros / business codes |
| `PO_Line_Item` | int | — | `int` | Cast PO_Line_Item to integer |
| `Material_ID` | String(alpha numeric) | Make upper letters | `string` | Cast Material_ID to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Plant_ID` | String(alpha numeric) | Make upper letters | `string` | Cast Plant_ID to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Storage_Location` | int | — | `string` | Cast Storage_Location to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Item_Category` | int | — | `int` | Cast Item_Category to integer |
| `Order_Quantity` | int | — | `double` | Cast Order_Quantity to double for quantity aggregation |
| `Unit_Of_Measure` | String | Make upper letters | `string` | Cast Unit_Of_Measure to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Net_Price` | int(decimal) | Net Price=Net Order Value/Quantity | `decimal(18,2)` | Cast Net_Price to decimal(18,2) for financial amount/price calculations; validate Net_Price = Net_Order_Value / Order_Quantity where quantity is not zero; validate/recalculate Net_Order_Value = Net_Price × Order_Quantity |
| `Net_Order_Value` | int(decimal) | Net Order Value = Net Price × Quantity | `decimal(18,2)` | Cast Net_Order_Value to decimal(18,2) for financial amount/price calculations; validate Net_Price = Net_Order_Value / Order_Quantity where quantity is not zero; validate/recalculate Net_Order_Value = Net_Price × Order_Quantity |
| `Item_Status` | String | Make 1st letter upper | `string` | Cast Item_Status to string; trim spaces and convert to Proper Case using initcap(lower()) |
| `PO_Line_Last_Changed_Date` | Date | — | `date` | Convert PO_Line_Last_Changed_Date to date using to_date() |
| `Created_Date` | Date | — | `date` | Convert Created_Date to date using to_date() |
| `Last_Modified_Date` | Date | — | `date` | Convert Last_Modified_Date to date using to_date() |

## Account Assignment
**Target table:** `SILVER_account_assignment`

| Source Column | Source Data Type | Business Rule | Target Spark Type | Transformation Applied |
|---|---|---|---|---|
| `PO_Number` | int | — | `string` | Cast PO_Number to string to preserve leading zeros / business codes |
| `PO_Line_Item` | int | — | `int` | Cast PO_Line_Item to integer |
| `Account_Assignment_Category` | String | Make upper letters<br>If it is K then internal order and Project should be blank<br>If P, Cost center and internal order should be blank<br>If F, cost center and project should be blank | `string` | Cast Account_Assignment_Category to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case; apply account assignment rule for K/P/F fields |
| `Cost_Center_ID` | String(alpha numeric) | Make upper letters | `string` | Cast Cost_Center_ID to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `GL_Account` | int | — | `string` | Cast GL_Account to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Internal_Order_ID` | String(alpha numeric) | Make upper letters | `string` | Cast Internal_Order_ID to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `WBS_Element` | String(alpha numeric) | Make upper letters | `string` | Cast WBS_Element to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Account_Assignment_Amount` | int(decimal) | — | `decimal(18,2)` | Cast Account_Assignment_Amount to decimal(18,2) for financial amount/price calculations |
| `Currency_Code` | String | Make upper letters | `string` | Cast Currency_Code to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Created_Date` | Date | — | `date` | Convert Created_Date to date using to_date() |
| `Last_Modified_Date` | Date | — | `date` | Convert Last_Modified_Date to date using to_date() |

## Goods Receipts
**Target table:** `SILVER_goods_receipt`

| Source Column | Source Data Type | Business Rule | Target Spark Type | Transformation Applied |
|---|---|---|---|---|
| `Material_Doc_Number` | int | — | `string` | Cast Material_Doc_Number to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Material_Doc_Year` | int | — | `int` | Cast Material_Doc_Year to integer |
| `PO_Number` | int | — | `string` | Cast PO_Number to string to preserve leading zeros / business codes |
| `PO_Line_Item` | int | — | `int` | Cast PO_Line_Item to integer |
| `Material_ID` | String(alpha numeric) | Make upper letters | `string` | Cast Material_ID to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Plant_ID` | String(alpha numeric) | Make upper letters | `string` | Cast Plant_ID to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Received_Quantity` | int | — | `double` | Cast Received_Quantity to double for quantity aggregation |
| `Unit_Of_Measure` | String | Make upper letters | `string` | Cast Unit_Of_Measure to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Movement_Type` | int | — | `int` | Cast Movement_Type to integer |
| `Posting_Date` | Date | — | `date` | Convert Posting_Date to date using to_date() |
| `Created_Date` | Date | — | `date` | Convert Created_Date to date using to_date() |
| `Last_Modified_Date` | Date | — | `date` | Convert Last_Modified_Date to date using to_date() |

## Invoice Items
**Target table:** `SILVER_invoice_items`

| Source Column | Source Data Type | Business Rule | Target Spark Type | Transformation Applied |
|---|---|---|---|---|
| `Invoice_Doc_Number` | int | — | `string` | Cast Invoice_Doc_Number to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Fiscal_Year` | int | — | `int` | Cast Fiscal_Year to integer |
| `PO_Number` | int | — | `string` | Cast PO_Number to string to preserve leading zeros / business codes |
| `PO_Line_Item` | int | — | `int` | Cast PO_Line_Item to integer |
| `Material_ID` | String(alpha numeric) | Make upper letters | `string` | Cast Material_ID to string to preserve leading zeros / business codes; trim spaces and convert to UPPER case |
| `Invoiced_Quantity` | int | — | `double` | Cast Invoiced_Quantity to double for quantity aggregation |
| `Invoice_Amount` | int(decimal) | — | `decimal(18,2)` | Cast Invoice_Amount to decimal(18,2) for financial amount/price calculations |
| `Invoice_Status` | String | Make 1st letter upper | `string` | Cast Invoice_Status to string; trim spaces and convert to Proper Case using initcap(lower()) |
| `Posting_Date` | Date | — | `date` | Convert Posting_Date to date using to_date() |
| `Created_Date` | Date | — | `date` | Convert Created_Date to date using to_date() |
| `Last_Modified_Date` | Date | — | `date` | Convert Last_Modified_Date to date using to_date() |
