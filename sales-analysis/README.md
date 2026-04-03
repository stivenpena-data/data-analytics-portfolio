# Sales Performance Analysis
### Retail Business Intelligence | SQL · Excel · Power BI

---

## Business Problem

A retail company with operations across 4 regions and 3 product categories needed to understand **where revenue was being lost and where to double down**.

The dataset contains **9,994 transactions** spanning 4 years (2014–2017). The goal: transform raw sales data into decisions.

---

## Key Findings

| Metric | Value |
|---|---|
| Total Revenue | $2,026,591 |
| Total Profit | $276,352 |
| Profit Margin | 13.6% |
| Total Transactions | 9,994 |

### Finding 1 — The West region dominates, but Central is underperforming
| Region | Revenue | Share | Profit |
|---|---|---|---|
| West | $642,190 | 31.7% | $103,416 |
| East | $579,343 | 28.6% | $88,517 |
| Central | $451,973 | 22.3% | $41,340 |
| South | $353,086 | 17.4% | $43,078 |

> **Business insight:** Central generates 22% of revenue but only 15% of profit. Pricing or discount strategy needs review in this region.

### Finding 2 — Technology drives revenue, Furniture destroys margin
| Category | Revenue | Share | Profit |
|---|---|---|---|
| Technology | $808,381 | 39.9% | $140,586 |
| Office Supplies | $698,483 | 34.5% | $118,821 |
| Furniture | $519,728 | 25.6% | $16,944 |

> **Business insight:** Furniture represents 25.6% of revenue but only 6.1% of profit. Tables and Bookcases are operating at a **net loss** (-$13,339 and -$3,003 respectively).

### Finding 3 — Q4 generates 84% more revenue than the average quarter
| Period | Revenue |
|---|---|
| Q4 average (2014–2017) | $192,666 |
| Q1–Q3 average | $104,660 |
| Q4 premium | **+84%** |

> **Business insight:** The business is heavily Q4-dependent. A strategy to reduce seasonal variance (promotions in Q1/Q2) could stabilize cash flow significantly.

### Finding 4 — Phones and Chairs lead sub-categories, Machines underperform
| Sub-Category | Revenue | Profit |
|---|---|---|
| Phones | $324,220 | $43,327 |
| Chairs | $249,453 | $21,080 |
| Binders | $199,298 | $32,403 |
| Machines | $170,455 | $686 ⚠️ |

> **Business insight:** Machines generate $170K in revenue but only $686 in profit — likely due to aggressive discounting. Discount strategy review recommended.

---

## Business Recommendations

1. **Exit or reprice Tables** — currently losing $13,339. Either increase price or discontinue.
2. **Reduce discounts on Machines** — $170K revenue generating near-zero profit signals over-discounting.
3. **Invest in West and East** — highest ROI regions. Replicate their sales strategy in Central.
4. **Launch Q1/Q2 promotions** — reduce 84% Q4 dependency with targeted off-season campaigns.

---

## Tools & Process

```
Raw CSV (9,994 rows)
    → SQL: data cleaning + aggregations
    → Excel: pivot analysis + trend modeling  
    → Power BI: interactive dashboard
```

**Dashboard:** Revenue trends · Regional breakdown · Category performance · Profit margin by sub-category

---

## Dashboard Preview

![Sales Dashboard](powerbi_dashboard/sales_dashboard.png)

---

## About

Built by **Stiven Peña** — Project Manager & Data Analyst  
[LinkedIn](https://www.linkedin.com/in/stivenpena-data) · [Portfolio](https://github.com/stivenpena-data)
