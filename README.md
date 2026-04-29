# 🛒 SuperStore Sales Analysis (2015 - 2018)

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)
![Matplotlib](https://img.shields.io/badge/Matplotlib-11557C?style=for-the-badge&logo=matplotlib&logoColor=white)
![Seaborn](https://img.shields.io/badge/Seaborn-4C72B0?style=for-the-badge&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-00758F?style=for-the-badge&logo=mysql&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-D71F00?style=for-the-badge&logo=sqlalchemy&logoColor=white)
![Power BI](https://img.shields.io/badge/PowerBI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)


[View interactive dashboard here on the Power BI Service](https://app.fabric.microsoft.com/reportEmbed?reportId=f4c9a01d-7a1a-4b80-9829-347b188ea7ba&autoAuth=true&ctid=75898210-fb55-496e-b012-e1c03d13ab60&actionBarEnabled=true&reportCopilotInEmbed=true)

## 📌 Project Overview

A complete end-to-end **Sales Analysis** project for a fictional SuperStore covering
**2015 to 2018**. The project follows a full ETL pipeline:

```
Raw CSV Data → Python (Extract & Transform) → MySQL (Load) → Power BI (Visualize)
```

### 🎯 Objectives

- Analyze sales, profit, and order trends across 4 years
- Identify top-performing products, categories, and regions
- Build an interactive Power BI dashboard with 5 pages
- Write SQL queries for business problem solving

---

## 📁 Project Structure

```
SuperStore-Sales-Analysis/
│
|    📂 data/
│   └── Superstore_sales.csv             # Raw Dataset
├── 📓 Superstoresales_Analysis.ipynb     # Python ETL Notebook
├── 🗄️  Basic_query.sql                   # Basic SQL Queries
├── 🗄️  Advance_query.sql                 # Business Problem SQL Queries
├── 📊 Super_store_sales_analysis.pbix    # Power BI Dashboard
|
└── 📄 README.md                          # Project Documentation
```

---

## 🔄 ETL Pipeline

### Phase 1 — Extract (Python)

```python
import pandas as pd
import numpy as np

# Read raw CSV
df = pd.read_csv("Superstore.csv", encoding="latin1")
print(df.shape)
print(df.dtypes)
print(df.isnull().sum())
```

### Phase 2 — Transform (Python)

```python
# Data Cleaning
df.drop_duplicates(inplace=True)
df.dropna(subset=["Order ID", "Customer ID"], inplace=True)
df.columns = df.columns.str.strip().str.replace(" ", "_")

# Fix Data Types
df["Order_Date"] = pd.to_datetime(df["Order_Date"])
df["Ship_Date"]  = pd.to_datetime(df["Ship_Date"])

# Feature Engineering
df["Profit_Margin"]  = df["Profit"] / df["Sales"]
df["COGS"]           = df["Sales"] - df["Profit"]
df["Days_to_Ship"]   = (df["Ship_Date"] - df["Order_Date"]).dt.days
df["Start_of_Month"] = df["Order_Date"].dt.to_period("M").dt.to_timestamp()

# Build Star Schema Tables
customers_dim = df[["Customer_ID","Customer_Name","Segment"]].drop_duplicates()
products_dim  = df[["Product_ID","Product_Name","Category","Sub_Category"]].drop_duplicates()
orders_dim    = df[["Order_ID","Order_Date","Ship_Date","Ship_Mode",
                    "Region","State","City","Postal_Code","Days_to_Ship"]].drop_duplicates()
fact          = df[["Row_ID","Order_ID","Customer_ID","Product_ID",
                    "Sales","Quantity","Profit","Profit_Margin","COGS"]]
```

### Phase 3 — Load (Python → MySQL)

```python
from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://root:password@localhost:3306/SuperstoreDB"
)

fact.to_sql("order_details_fact", engine, if_exists="replace", index=False)
customers_dim.to_sql("customers_dim",  engine, if_exists="replace", index=False)
products_dim.to_sql("products_dim",    engine, if_exists="replace", index=False)
orders_dim.to_sql("orders_dim",        engine, if_exists="replace", index=False)

print("✅ All tables loaded successfully!")
```

---

## 🗄️ Database Schema (Star Schema)

```
                    ┌─────────────────┐
                    │  customers_dim  │
                    │─────────────────│
                    │ Customer_ID (PK)│
                    │ Customer_Name   │
                    │ Segment         │
                    └────────┬────────┘
                             │
┌──────────────┐    ┌────────▼──────────────┐    ┌─────────────────┐
│ orders_dim   │    │  order_details_fact   │    │  products_dim   │
│──────────────│    │───────────────────────│    │─────────────────│
│ Order_ID(PK) ├────│ Row_ID (PK)           │    │ Product_ID (PK) │
│ Order_Date   │    │ Order_ID (FK)         ├────│ Product_Name    │
│ Ship_Date    │    │ Customer_ID (FK)      │    │ Category        │
│ Ship_Mode    │    │ Product_ID (FK)       │    │ Sub_Category    │
│ Region       │    │ Sales                 │    └─────────────────┘
│ State        │    │ Quantity              │
│ City         │    │ Profit                │
│ Days_to_Ship │    │ Profit_Margin         │
└──────────────┘    |                  │
                    └───────────────────────┘
```

---

## 📊 Power BI Dashboard

### Dashboard Pages

| Page                      | Content                                                              |
| ------------------------- | -------------------------------------------------------------------- |
| 🏠 **Home**               | KPI Cards, Orders by Sub_Category, Sales by Month                    |
| 📈 **Executive Overview** | Units Sold, Orders by Category, Avg Order Value                      |
| 🗺️ **Categorical View**   | Map, Profit Margin Gauge, Sales by Ship Mode & Category              |
| 👥 **Customer Analytics** | Customer Table, Decomposition Tree, Sales by Category                |
| 📉 **Market Analysis**    | Profit Margin by Category (Line+Column), Treemap, Customers by State |

### Key KPI Metrics

| Metric               | Value      |
| -------------------- | ---------- |
| Total Revenue        | $2,221,225 |
| Total Orders         | 4,809      |
| Profit Margin %      | -1.39%     |
| Profitable Rate %    | 63%        |
| Average Order Value  | $459.5     |
| Total Units Sold     | 9,914      |
| Revenue per Customer | $2,852     |
| Avg Days to Ship     | 4 days     |
| Profitable Orders    | 3,103      |

### DAX Measures

```dax
Total Revenue     = SUM(order_details_fact[Sales])
Total Profit      = SUM(order_details_fact[Profit])
Profit Margin %   = DIVIDE([Total Profit], [Total Revenue])
Total Orders      = COUNTROWS(order_details_fact)
Profitable Orders = COUNTROWS(FILTER(order_details_fact, [Profit] > 0))
Profitable Rate % = DIVIDE([Profitable Orders], [Total Orders])
Avg Order Value   = DIVIDE([Total Revenue], [Total Orders])
Avg Days to Ship  = AVERAGE(orders_dim[Days_to_Ship])

-- Dynamic Gauge Color
Gauge Fill Color =
IF([Profit Margin %] >= 0.05, "#27AE60",
    IF([Profit Margin %] >= 0, "#F39C12", "#C0392B"))
```

---

## 🗄️ SQL Analysis

### Business Problem Queries (`Problem_query.sql`)

| Query                              | Description                |
| ---------------------------------- | -------------------------- |
| Total Revenue & Avg Sales          | Overall revenue summary    |
| Orders by Year                     | Year-wise order trend      |
| Orders by Month                    | Monthly order distribution |
| Orders by Day of Week              | Day-wise order patterns    |
| Highest Units Sold by Sub-Category | Product performance        |
| Highest Profit Sub-Category        | Profitability analysis     |
| Top 10 Cities by Orders            | Geographic analysis        |
| Average Sales by Category          | Category benchmarking      |
| Total Revenue by Category          | Category revenue breakdown |

### Advanced Queries (`Advance_query.sql`)

| Query                                | Technique Used                     |
| ------------------------------------ | ---------------------------------- |
| Sales & Profit by Segment            | GROUP BY, JOIN, Aggregation        |
| Revenue by Region (Above Average)    | Subquery, HAVING                   |
| Top 10 Customers by Revenue          | CTE, ROW_NUMBER(), Window Function |
| Sales by Category with Profit Status | CASE Statement, GROUP BY           |

#### Sample Advanced Query — Top 10 Customers

```sql
WITH customer_revenue AS (
    SELECT c.Customer_ID, c.Customer_Name, c.Segment,
           COUNT(DISTINCT o.Order_ID) AS Order_count,
           SUM(od.Sales) AS Total_Revenue,
           SUM(od.Profit) AS Total_Profit
    FROM customers c
    INNER JOIN orders o ON c.Customer_ID = o.Customer_ID
    INNER JOIN order_details od ON o.Order_ID = od.Order_ID
    GROUP BY c.Customer_ID, c.Customer_Name, c.Segment
)
SELECT
    ROW_NUMBER() OVER (ORDER BY Total_Revenue DESC) AS Rank,
    Customer_Name, Segment, Order_count,
    ROUND(Total_Revenue, 2) AS Total_Revenue,
    ROUND(Total_Profit, 2) AS Total_Profit
FROM customer_revenue
LIMIT 10;
```

---

## 🔑 Key Insights

- 📦 **Binders & Paper** are the highest selling sub-categories by units
- 🏆 **Technology** leads in revenue ($827K) followed by Furniture ($729K)
- 📍 **California** has the most customers, **Washington** has highest profit
- 🚚 **Standard Class** is the most used shipping mode (59%)
- 📉 **Overall Profit Margin is -1.39%** indicating the business is at a slight loss
- 💰 **63% orders are profitable** — discount strategy needs review for the remaining 37%
- 📅 Sales show an **upward trend from 2015 to 2018**

---

## 🛠️ Tech Stack

| Tool                   | Purpose                          |
| ---------------------- | -------------------------------- |
| **Python 3**           | Data extraction & transformation |
| **Pandas**             | Data manipulation & cleaning     |
| **NumPy**              | Numerical computations           |
| **Matplotlib/seaborn** | Visualization                    |
| **SQLAlchemy**         | Python-MySQL connection          |
| **PyMySQL**            | MySQL driver                     |
| **MySQL**              | Data storage & SQL analysis      |
| **Power BI Desktop**   | Dashboard & visualization        |
| **DAX**                | Power BI calculations            |
| **Jupyter Notebook**   | Python development environment   |

---

## ⚙️ Setup & Installation

### Prerequisites

- Jupyter Notebook / Google Coolab
- Python 3.13+
- MySQL Server
- Power BI Desktop

### Step 1 — Clone Repository

```bash
git clone https://github.com/Ranjan234/superstore-sales-analysis.git
cd superstore-sales-analysis
```

### Step 2 — Install Python Libraries

```bash
pip install pandas numpy sqlalchemy pymysql openpyxl jupyter
```

### Step 3 — Setup MySQL Database

```sql
CREATE DATABASE SuperstoreDB;
USE SuperstoreDB;
```

### Step 4 — Run Python ETL Notebook

```bash
jupyter notebook Superstoresales_Analysis.ipynb
```

> Run all cells — this will clean data and load all 4 tables into MySQL

### Step 5 — Run SQL Queries

- Open **MySQL Workbench**
- Run `Problem_query.sql` for basic analysis
- Run `Advance_query.sql` for advanced analysis

### Step 6 — Open Power BI Dashboard

- Open `Super_store_sales_analysis.pbix` in Power BI Desktop
- Update MySQL connection if needed:
  - **Home → Transform Data → Data Source Settings**
  - Update server: `localhost` and database: `SuperstoreDB`

---

## 📸 Dashboard Screenshots

| Page               | Screenshot                                           |
| ------------------ | ---------------------------------------------------- |
| Home               | ![Home](https://github.com/Ranjan234/SuperStore-Sales-Analysis/commit/333f472147ac88ae96f41dfb3e7b25169f5f453f)               |
| Executive Overview | ![Executive](PowerBI/screennshots/executive.png)     |
| Categorical View   | ![Categorical](PowerBI/screennshots/categorical.png) |
| Customer Analytics | ![Customer](PowerBI/screennshots/customer.png)       |
| Market Analysis    | ![Market](PowerBI/screennshots/market.png)           |

---

## 🤝 Connect

If you found this project helpful, please ⭐ star the repository!

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/soumyaranjansahoo0/)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Ranjan234)

---

_Made with ❤️ using Python, MySQL & Power BI_
