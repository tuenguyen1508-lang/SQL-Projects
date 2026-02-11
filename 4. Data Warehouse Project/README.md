## Building a Medallion Data Warehouse for Reporting and Insights

This project uses Microsoft SQL Server to build a data warehouse from scratch, integrating data from CRM and ERP source systems. It includes an end-to-end ETL process (extract, transform, load), data quality checks, and a star schema model designed for efficient analytics and reporting.

---

## Data Architecture (Medallion: Bronze, Silver, Gold)

The warehouse follows the Medallion Architecture to separate raw, cleaned, and business-ready data:

![Data Architecture](https://github.com/user-attachments/assets/1e84b496-c516-4e38-8f82-180d1b0a69e1)

- **Bronze Layer (Raw)**
  - Stores source data as-is from CRM and ERP
  - Ingested into SQL Server using CSV files

- **Silver Layer (Cleansed and Standardized)**
  - Cleans, standardizes, and normalizes data
  - Improves data quality and consistency across sources

- **Gold Layer (Business-Ready)**
  - Models curated data into a star schema
  - Optimized for analytics, reporting, and BI tools

---

## Data Flow (From Source Systems to Reporting)

Data moves through the pipeline in a structured sequence:

![Data Flow](https://github.com/user-attachments/assets/47211939-874f-4655-9781-9fd2fbba5a6c)

1. **Extract**
   - Collect CRM and ERP data in CSV format

2. **Transform**
   - Perform deduplication, formatting, and standardization
   - Integrate data across systems and resolve inconsistencies

3. **Load**
   - Store cleaned outputs in fact and dimension tables for fast querying

**Key relationships and integration:**
- CRM data includes sales transactions, customer details, and product history
- ERP data provides customer locations, product categories, and additional attributes
- Primary and foreign keys link customers, products, and sales across sources
- ERP customer tables connect to CRM customer entities, while ERP product category tables enrich CRM product data

![Data Integration](https://github.com/user-attachments/assets/7a8b6c25-31c4-495e-bbcc-1f46d4b74614)

---

## Data Model (Star Schema)

The final Gold layer uses a star schema optimized for performance:

![Data Model](https://github.com/user-attachments/assets/d636577f-390c-4ffe-9b93-e868333631e9)

- **Fact table**
  - `fact_sales`: transactional sales records linked to dimensions

- **Dimension tables**
  - `dim_customers`: consolidated customer details from CRM and ERP
  - `dim_products`: product history combined with product categories

This structure supports fast aggregations and scalable reporting.

---

## Deployment Guide (Step-by-Step)

Follow the SQL scripts in sequence to deploy the warehouse.

### 1) Initialize Database and Environment
- Navigate to the `scripts` folder
- Run `init_database.sql` to create the database and schemas

### 2) Bronze Layer (Raw Storage)
- Navigate to the `bronze` folder
- Run `ddl_bronze.sql` to create raw tables and constraints
- Run `proc_load_bronze.sql` to ingest CRM and ERP CSV files into Bronze tables

### 3) Silver Layer (Cleansing and Transformation)
- Navigate to the `silver` folder
- Run `ddl_silver.sql` to create Silver tables
- Run `proc_load_silver.sql` to transform Bronze to Silver and apply cleansing rules
- At this stage, Silver data is clean, standardized, and structured

### 4) Gold Layer (Business-Ready Model)
- Navigate to the `gold` folder
- Run `ddl_gold.sql` to build the final fact and dimension tables and apply relationships
- The star schema is now ready for analytics and business insights

**Data quality testing:**
- A `tests` folder is included to validate Silver and Gold layer quality (standardization checks, null checks, negative value checks, trimming unwanted spaces, and other consistency rules)

---

## Exploratory Data Analysis (EDA)

After the warehouse is deployed, EDA helps you understand the dataset structure before deeper analysis.

**Why EDA matters:**
- Identify how many datasets exist
- Review columns, data types, and constraints
- Separate dimensions and measures
- Validate date ranges and distributions

**Step-by-step EDA process:**
- Navigate to the `Exploratory Data Analysis` folder
- Run scripts `01` to `06` to:
  - identify dimension and measure columns
  - analyze date ranges
  - explore key measures
  - perform magnitude and distribution analysis
  - run ranking analysis to classify performance levels

---

## Advanced Analytics to Extract Business Insights

Once the data is understood, the project performs business analysis using the Gold layer.

**Steps:**
- Navigate to the `Advanced Data Analytics for Business` folder
- Run scripts `01` to `07` in order to perform:

- **Trend Analysis**
  - Tracks how key business metrics change over time using `gold.fact_sales`

- **Cumulative Analysis**
  - Adds running totals and cumulative metrics to highlight long-term changes

- **Performance Analysis**
  - Evaluates yearly product performance vs product average and prior-year results

- **Part-to-Whole Analysis**
  - Measures which categories contribute the most to overall sales using:
    - `gold.fact_sales` (`sales_amount`)
    - `gold.dim_products` (`category`)

- **Data Segmentation**
  - Product cost segmentation (bucket products into cost ranges)
  - Customer spending segmentation (VIP, Regular, New based on lifespan and spending)

- **Final Reporting Views**
  - `gold.report_customers`: customer identity, behaviors, segments, and KPIs for dashboards
  - `gold.report_products`: product attributes, performance segments, and KPIs for reporting

---

## Conclusion

This project demonstrates how to build a scalable data warehouse in SQL Server using best practices in ETL, data modeling, and star schema design. The layered architecture improves data quality and maintainability, while the Gold layer enables efficient reporting and analytics for business decision-making.

