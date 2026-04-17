# Supply Chain Inventory Analytics
> End-to-end analytics project using SQL (descriptive & diagnostic) + Machine Learning (Phase 2)

![SQL](https://img.shields.io/badge/SQL-MySQL-blue)
![Status](https://img.shields.io/badge/Phase%201-Complete-green)
![ML](https://img.shields.io/badge/Phase%202-In%20Progress-orange)

---

## Dataset Overview
- **100 rows × 24 columns** representing the full product lifecycle from supplier to consumer
- **Product types:** Skincare, Haircare, Cosmetics

| Domain | Columns |
|---|---|
| Product | SKU, Product type, Price |
| Operations & Inventory | Stock levels, Lead times, Order quantities, Availability |
| Financials | Revenue generated, Manufacturing costs, Shipping costs, Costs |
| Logistics & Suppliers | Supplier name, Shipping carriers, Shipping times, Transportation modes, Routes |
| Quality | Inspection results, Defect rates |

---

## Phase 1 — SQL Descriptive & Diagnostic Analysis
Goal: Answer *"What happened and why?"*

### 1. Data Cleaning & Staging
- Created `supply_staging` as a working copy to protect raw data
- Removed duplicate records; validated SKU–product type consistency
- Trimmed whitespace from categorical columns (`Product type`, `Transportation modes`, `Location`)

### 2. Product Analysis
- Total and average revenue by product type
- Top-10 best-selling SKUs by units sold
- Top-3 revenue SKUs per product category using `DENSE_RANK()` window function
- Average lead time across all products
  
   ** Snapshot of the resutls **
   https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/avg_leadtime.csv

### 3. Procurement Analysis
- Average lead time per supplier
- Top 3 suppliers with highest defect rates
- Most-used supplier per product type (correlated subquery)

### 4. Production Analysis
- Total production volume per supplier
- SKU and supplier with the lowest defect rate
- Average manufacturing cost by product type
- Relationship between production volume and defect rate

### 5. Logistics Analysis
- Total shipping cost by carrier
- Average shipping time for air transport
- Routes with above-average shipping cost (subquery benchmark)
- Top carrier per location by order volume
- Carrier performance classification: `Good / Average / Poor` using `CASE WHEN` with ±20% dynamic threshold

### SQL Techniques Used
`Window functions (DENSE_RANK)` · `Correlated subqueries` · `GROUP BY / HAVING` · 
`CASE WHEN` · `Staging table pattern` · `Aggregate functions` · `Dynamic benchmarking`

---

## Phase 2 — Machine Learning (Upcoming)
| Model | Goal |
|---|---|
| Demand forecasting | Predict future order quantities |
| Defect rate classification | Flag high-risk suppliers |
| Inventory optimization | Detect overstocked / understocked SKUs |
| Shipping cost regression | Model cost by route, carrier, and transport mode |

---

## Tools & Stack
- **Database:** MySQL
- **Analysis:** SQL (descriptive & diagnostic)
- **ML (planned):** Python, scikit-learn, pandas
- **Visualization (planned):** Power BI / Tableau
