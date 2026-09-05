# E-Commerce Sales & Customer Analytics

## About the Project

This project is an end-to-end data analytics project built to understand how an e-commerce business is performing and where there are opportunities to improve sales and customer experience.

I worked with the Olist Brazilian E-Commerce Public Dataset, which contains around 99K orders and more than 112K order items across multiple related datasets.

The main goal was to take raw e-commerce data, clean and explore it, answer business questions using SQL, and finally present the findings through an interactive Power BI dashboard.

---

## Business Questions

Through this project, I wanted to answer questions such as:

- How are sales performing over time?
- Which product categories generate the most revenue?
- Which products perform the best?
- Where are the customers located?
- How do customers behave after their first purchase?
- Which payment methods are most commonly used?
- How well are orders being delivered?
- Does delivery performance relate to customer satisfaction?
- How are customers distributed between one-time, repeat, and loyal customers?

---

## Dataset

The project uses the **Olist Brazilian E-Commerce Public Dataset**.

The dataset contains multiple related tables covering:

- Orders
- Customers
- Products
- Order Items
- Payments
- Reviews
- Sellers
- Geolocation

For the analysis, I worked mainly with orders, customers, products, order items, payments, and reviews.

---

## Tools & Technologies

- **Python** – Data cleaning and exploratory data analysis
- **Pandas & NumPy** – Data manipulation and analysis
- **Matplotlib & Seaborn** – Data visualization
- **MySQL** – SQL-based business analysis
- **Power BI** – Interactive dashboard development
- **Power Query** – Data preparation
- **DAX** – Measures and KPI calculations
- **Jupyter Notebook** – Python analysis

---
---

## Power BI Dashboard

### Executive Sales Overview

![Executive Sales Overview](screenshots/slide1.jpg)

### Customer & Product Analytics

![Customer & Product Analytics](screenshots/slide2.jpg)

---

## Project Workflow

The project was completed in the following stages:

### 1. Data Cleaning & Exploration

I started by loading the different CSV files into Python and checking their structure, data types, missing values, and duplicates.

I converted the relevant date columns, checked data quality, and prepared cleaned datasets for further analysis.

### 2. SQL Analysis

I loaded the data into MySQL and used SQL to answer business questions related to:

- Revenue
- Orders
- Average Order Value
- Product categories
- Top products
- Customers
- Customer states
- Repeat purchases
- Payment methods
- Delivery performance
- Customer reviews
- Seller performance

I also used SQL concepts such as:

- Joins
- Aggregations
- GROUP BY
- CASE WHEN
- HAVING
- Subqueries
- CTEs
- Window functions
- RANK()

### 3. Power BI Dashboard

The final analysis was presented through an interactive Power BI dashboard.

The dashboard includes:

- Total Revenue
- Total Orders
- Unique Customers
- Average Order Value
- Average Review Score
- Revenue trends
- Revenue by product category
- Orders by customer state
- Top products by revenue
- Payment method distribution
- Customer review distribution
- Delivery performance
- Customer segmentation
- Category performance
- Customer satisfaction by delivery status

Slicers were also added to make the dashboard interactive and allow users to explore the data by date, state, and product category.

---

## Customer Segmentation

I created a simple customer segmentation based on the number of orders placed:

| Segment | Definition |
|--------|------------|
| One-time | 1 order |
| Repeat | 2–3 orders |
| Loyal | 4+ orders |

This helped me look beyond overall sales and understand customer retention patterns.

---

## Key Insights

Some of the main areas I explored through the analysis were:

- Revenue and order trends over time
- Categories contributing the most revenue
- Geographic distribution of customers
- Customer retention and repeat purchasing
- Payment method preferences
- Delivery performance
- Relationship between delivery status and review scores
- Product and seller performance

One important observation from the customer segmentation analysis was that the majority of customers were one-time purchasers, highlighting a potential opportunity to improve customer retention and repeat purchases.

---

## Repository Structure

```text
ECommerce-Sales-Customer-Analytics/
│
├── 01_Data_Exploration.ipynb
│
├── ecommerce_analysis.sql
│
├── powerbi/
│   └── ECommerce_Sales_Customer_Analytics.pbix
│
└── README.md
