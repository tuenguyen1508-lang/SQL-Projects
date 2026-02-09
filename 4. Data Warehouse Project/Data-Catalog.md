# Data Catalog for Gold Layer

## Overview
The Gold Layer is the curated, business-facing dataset designed for analytics and reporting. It is organised as a star schema, combining **dimension views** (descriptive context) and a **fact view** (measurable business activity).

---

## 1. `gold.dim_customers`
- **Purpose:** Holds customer information enhanced with demographic attributes and location details.

### Columns
| Column Name     | Data Type    | Description |
|----------------|--------------|-------------|
| customer_key   | INT          | Warehouse-generated surrogate key that uniquely identifies each customer row in the dimension. |
| customer_id    | INT          | The system’s unique numeric identifier for the customer. |
| customer_number| NVARCHAR(50) | A business/customer reference code used for identification and tracking. |
| first_name     | NVARCHAR(50) | Customer’s given name as stored in source systems. |
| last_name      | NVARCHAR(50) | Customer’s family name/surname as stored in source systems. |
| country        | NVARCHAR(50) | Customer’s country/region of residence (e.g., “Australia”). |
| marital_status | NVARCHAR(50) | Customer’s marital status (e.g., “Single”, “Married”). |
| gender         | NVARCHAR(50) | Standardised gender value (e.g., “Male”, “Female”, “n/a”). |
| birthdate      | DATE         | Customer’s date of birth in YYYY-MM-DD format. |
| create_date    | DATE         | Date the customer record was originally created in the source system. |

---

## 2. `gold.dim_products`
- **Purpose:** Provides product master data and key attributes used for grouping and analysis.

### Columns
| Column Name           | Data Type    | Description |
|----------------------|--------------|-------------|
| product_key          | INT          | Warehouse-generated surrogate key that uniquely identifies each product row in the dimension. |
| product_id           | INT          | Internal unique identifier for the product. |
| product_number       | NVARCHAR(50) | Business product code used for classification and tracking. |
| product_name         | NVARCHAR(50) | Human-readable product name describing the item. |
| category_id          | NVARCHAR(50) | Identifier for the product’s category, used to link to category metadata. |
| category             | NVARCHAR(50) | High-level grouping for the product (e.g., Bikes, Components). |
| subcategory          | NVARCHAR(50) | More specific grouping within the category. |
| maintenance_required | NVARCHAR(50) | Flag/value indicating whether maintenance applies (e.g., “Yes”, “No”). |
| cost                 | INT          | Product cost/base value captured in whole currency units. |
| product_line         | NVARCHAR(50) | Product line/series label (e.g., Road, Mountain). |
| start_date           | DATE         | Date the product became active/available in the system. |

---

## 3. `gold.fact_sales`
- **Purpose:** Contains sales transactions at the line-item level for performance reporting and analysis.

### Columns
| Column Name   | Data Type    | Description |
|--------------|--------------|-------------|
| order_number  | NVARCHAR(50) | Unique sales order reference (e.g., “SO54496”). |
| product_key   | INT          | Surrogate key that links the row to the product dimension. |
| customer_key  | INT          | Surrogate key that links the row to the customer dimension. |
| order_date    | DATE         | Date the order was created/placed. |
| shipping_date | DATE         | Date the order was shipped. |
| due_date      | DATE         | Date payment was due for the order. |
| sales_amount  | INT          | Total value of the sales line in whole currency units. |
| quantity      | INT          | Number of units sold on the line. |
| price         | INT          | Unit price for the line in whole currency units. |
