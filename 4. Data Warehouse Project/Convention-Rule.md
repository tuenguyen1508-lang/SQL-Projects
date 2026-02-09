This document describes the naming standards applied across the data warehouse for schemas, tables, views, columns, and other database objects.

## **Table of Contents**

1. [General Principles](#general-principles)  
2. [Table Naming Conventions](#table-naming-conventions)  
   - [Bronze Rules](#bronze-rules)  
   - [Silver Rules](#silver-rules)  
   - [Gold Rules](#gold-rules)  
3. [Column Naming Conventions](#column-naming-conventions)  
   - [Surrogate Keys](#surrogate-keys)  
   - [Technical Columns](#technical-columns)  
4. [Stored Procedure](#stored-procedure-naming-conventions)  

---

## **General Principles**

- **Style:** Use `snake_case` (lowercase letters with underscores to separate words).
- **Language:** All object names should be in English.
- **Reserved Keywords:** Avoid SQL reserved words when naming any object.

## **Table Naming Conventions**

### **Bronze Rules**
- Table names must begin with the source system identifier and keep the original source table name (no renaming).
- **Pattern:** `<sourcesystem>_<entity>`  
  - `<sourcesystem>`: Source platform name (e.g., `crm`, `erp`)  
  - `<entity>`: Exact table name from the source  
  - Example: `crm_customer_info` → customer data sourced from CRM

### **Silver Rules**
- Table names follow the same structure as Bronze: start with the source system name and preserve the source entity name.
- **Pattern:** `<sourcesystem>_<entity>`  
  - Example: `crm_customer_info` → cleaned/standardised customer data from CRM

### **Gold Rules**
- Gold objects should use clear, business-friendly names and begin with a category prefix that explains the table’s role.
- **Pattern:** `<category>_<entity>`  
  - `<category>`: Table role such as `dim` (dimension) or `fact` (fact)  
  - `<entity>`: Business-aligned name (e.g., `customers`, `products`, `sales`)  
  - Examples:  
    - `dim_customers` → customer dimension table  
    - `fact_sales` → sales transactions fact table  

#### **Glossary of Category Patterns**

| Pattern    | Meaning           | Example(s) |
|------------|-------------------|------------|
| `dim_`     | Dimension table   | `dim_customer`, `dim_product` |
| `fact_`    | Fact table        | `fact_sales` |
| `report_`  | Report table      | `report_customers`, `report_sales_monthly` |

## **Column Naming Conventions**

### **Surrogate Keys**
- Surrogate keys in dimension tables must end with `_key`.
- **Pattern:** `<table_name>_key`  
  - Example: `customer_key` → surrogate key in `dim_customers`

### **Technical Columns**
- System/metadata fields must start with the prefix `dwh_` followed by a meaningful description.
- **Pattern:** `dwh_<column_name>`  
  - Example: `dwh_load_date` → timestamp/date the row was loaded into the warehouse

## **Stored Procedure**

- Data load stored procedures must follow this naming format:
- **Pattern:** `load_<layer>`  
  - `<layer>`: `bronze`, `silver`, or `gold`  
  - Examples:  
    - `load_bronze` → loads data into the Bronze layer  
    - `load_silver` → loads data into the Silver layer
