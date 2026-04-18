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

### Phase 1 — SQL Descriptive & Diagnostic Analysis
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
  
 **Snapshot of the result**

  https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/avg_leadtime.csv

  https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/avg_price.csv

  https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/rev_rank.csv

  https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/revenuerank.csv
  
### 3. Procurement Analysis
- Average lead time per supplier
- Top 3 suppliers with highest defect rates
- Most-used supplier per product type (correlated subquery)

**Snapshot of the results**

  https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/topsupplier.csv
  
  https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/topsupplier.csv

  https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/avg_lead_time.csv

### 4. Production Analysis
- Total production volume per supplier
- SKU and supplier with the lowest defect rate
- Average manufacturing cost by product type
- Relationship between production volume and defect rate

**Snapshot of the result**

https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/total%20production.csv

https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/volvsdefect.csv

https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/avg_manufacturing.csv

https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/lowest%20defect.csv

### 5. Logistics Analysis
- Total shipping cost by carrier
- Average shipping time for air transport
- Routes with above-average shipping cost (subquery benchmark)
- Top carrier per location by order volume
- Carrier performance classification: `Good / Average / Poor` using `CASE WHEN` with ±20% dynamic threshold

**Snapshot of the result**

https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/avg_shiptime.csv

https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/location.csv

https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/routes.csv

https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/shipping%20carrier.csv

https://github.com/lethhgnhung-cloud/supply_chain_analytic/blob/main/image/top5vendor.csv

### SQL Techniques Used
`Window functions (DENSE_RANK)` · `Correlated subqueries` · `GROUP BY / HAVING` · 
`CASE WHEN` · `Staging table pattern` · `Aggregate functions` · `Dynamic benchmarking`

---

### Phase 2 — Machine Learning 

> **A Python analytics project on a 100-SKU supply chain dataset — combining EDA, unsupervised clustering, and SKU performance scoring to surface actionable operational insights.**

![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)
![Scikit-learn](https://img.shields.io/badge/Scikit--learn-F7931E?style=for-the-badge&logo=scikit-learn&logoColor=white)
![Seaborn](https://img.shields.io/badge/Seaborn-visualization-4C72B0?style=for-the-badge)

## 🎯 Project Overview

This project applies a 3-phase analytical framework to a supply chain dataset containing product, inventory, logistics, manufacturing, and quality information. Given the small sample size (~100 records), the focus is deliberately shifted from predictive modeling toward **descriptive intelligence and unsupervised pattern discovery** — techniques that yield reliable, interpretable insights regardless of dataset size.

| Attribute | Details |
|-----------|---------|
| **Language** | Python 3 (Google Colab) |
| **Dataset** | `supply_chain_data.csv` — 100 SKUs, 24 features |
| **Primary goal** | Insight generation, not prediction accuracy |
| **Techniques** | EDA · Clustering · SKU Scoring |

---

## 🔬 Analytical Pipeline

### Phase 1 — Correlation & Advanced EDA
Exploratory analysis using correlation heatmap, pairplot by product type, and boxplots of defect rates across suppliers, locations, and transportation modes.

**Objective:** Understand variable relationships before applying any algorithm — a critical foundation for small datasets where noise can mislead models.

---

### Phase 2 — Clustering (K-Means + PCA)
Applied PCA (2 components) for dimensionality reduction, followed by K-Means (k=3) to segment all 100 SKUs into behavioral clusters.

> **Note on PCA variance:** The 2 principal components explain ~18% of total variance. This is expected with 46 features post-encoding and means the 2D scatter is a rough approximation — cluster labels from the full feature space are more reliable than the visual positions.

**Cluster profiles identified:**
- **Cluster 0** — High stock, mid-range revenue: stable but potentially overstocked products
- **Cluster 1** — Mid performance: the broad "average" group
- **Cluster 2** — Operationally distinct: different logistics or cost profile warranting closer review

---

### Phase 3 — SKU Performance Scoring
Built a composite weighted score to rank all 100 SKUs on a 0–100 scale.

```python
Score = (0.40 × Revenue_generated)
      - (0.30 × Defect_rates)
      - (0.20 × Lead_times)
      - (0.10 × Stock_levels)
```

Scores were normalized using MinMaxScaler before ranking. Top 10 and bottom 10 SKUs were surfaced for prioritization decisions.

---

## 💡 Key Findings

**1. Defect rates vary significantly by supplier.**
Boxplot analysis shows clear differences in defect rate distribution across suppliers — some suppliers have both higher median defect rates and wider spread, suggesting inconsistent quality control.

**2. Clustering surfaces a distinct high-stock group.**
Cluster 0 shows elevated stock levels relative to mid-range revenue — a pattern consistent with overstocking or slow-moving inventory that wouldn't be visible from averages alone.

**3. SKU scoring reveals hidden underperformers.**
Several SKUs with moderate revenue rank poorly once defect rates and lead times are factored in — these would be overlooked by a revenue-only view.

**4. Price does not linearly drive revenue.**
Scatter analysis shows no strong linear relationship between price and revenue generated, indicating that sales volume and product category are stronger revenue drivers than price point alone.

---

## ⚠️ Limitations & Notes

| Issue | Context |
|-------|---------|
| **Small sample (n=100)** | Results should be treated as directional signals for exploration, not statistically conclusive findings |
| **PCA explains only 18% variance** | The 2D cluster visualization is approximate; cluster assignments are based on the full feature space and are more reliable than visual positions |
| **Weights in scoring are subjective** | The 0.40/0.30/0.20/0.10 weights in Phase 3 are heuristic — business stakeholders should validate and adjust these based on organizational priorities |

---

## Tools & Stack
- **Database:** MySQL
- **Analysis:** SQL (descriptive & diagnostic)
- **ML (planned):** Python, scikit-learn, pandas
- **Visualization (planned):** Power BI / Tableau
