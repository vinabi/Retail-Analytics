# Retail Sales and Customer Insights Analysis

Welcome to the **Retail Sales and Customer Insights Analysis** project! This repository contains SQL-based analysis of retail data, focusing on sales performance, customer behavior, and inventory management. The project explores a fictional retail company’s dataset to derive actionable insights that can inform business strategies.

---

## 📋 Project Overview

This project uses SQL to analyze sales, customers, and product data to uncover trends and patterns. It leverages advanced SQL features such as **window functions**, **CTEs**, **joins**, and **aggregations** to provide in-depth insights. Key focus areas include:

- **Sales Trends**  
- **Customer Segmentation**  
- **Product Profitability**  
- **Inventory Efficiency**

---

## 📊 Dataset Description

The dataset consists of four interrelated tables:

### 1. **Customers Table**
Details about the company's customers.
- `customer_id` (Primary Key)  
- `first_name`, `last_name`, `email`, `gender`, `date_of_birth`  
- `registration_date`, `last_purchase_date`

### 2. **Products Table**
Information about products in the inventory.
- `product_id` (Primary Key)  
- `product_name`, `category`, `price`, `stock_quantity`  
- `date_added`

### 3. **Sales Table**
Details about each sale made.
- `sale_id` (Primary Key)  
- `customer_id` (Foreign Key), `product_id` (Foreign Key)  
- `quantity_sold`, `sale_date`, `discount_applied`, `total_amount`

### 4. **Inventory Movements Table**
Tracks inventory changes.
- `movement_id` (Primary Key)  
- `product_id` (Foreign Key)  
- `movement_type` (`IN` for restock, `OUT` for sales), `quantity_moved`, `movement_date`

---

## 🎯 Key Objectives

### **Module 1: Sales Performance Analysis**
1. Calculate total sales per month (units and revenue).  
2. Determine the average discount applied monthly.  

### **Module 2: Customer Behavior and Insights**
3. Identify high-value customers and their details.  
4. Find the oldest customers born in the 1990s and their order details.  
5. Create customer segments (e.g., Low, Medium, High Spenders) based on total spending.

### **Module 3: Inventory and Product Management**
6. Identify products running low on stock and recommend restocking amounts.  
7. Analyze daily inventory movements (restock vs. sales).  
8. Rank products within each category by price.  

### **Module 4: Advanced Analytics**
9. Calculate the average order size by product.  
10. Identify products with recent restocking activity.

---

## 🛠️ SQL Features Used

This project employs advanced SQL concepts to handle complex queries efficiently:
- **Common Table Expressions (CTEs)**  
- **Window Functions**  
- **Subqueries**  
- **Joins** (Inner, Left, Right)  
- **Group By & Having Clauses**  
- **Aggregations** (SUM, AVG, COUNT)  
- **Case Statements**

---

## 📈 Insights Derived

1. **Sales Trends**: Monthly revenue trends and the impact of discounts on sales.  
2. **High-Value Customers**: Top spenders and their purchasing behaviors.  
3. **Customer Segmentation**: Grouping customers into categories based on their spending.  
4. **Inventory Management**: Stock levels, restocking recommendations, and product rankings.

---

## 📜 Deliverables
1. **SQL Queries**: Modularized SQL scripts for each module.
2. **Analysis Repor**t: Comprehensive report summarizing the findings.

---

## 🛠️ Setup Instructions

1. Clone the repository:  
   ```bash
   git clone https://github.com/vinabi/retail-analytics.git
   cd retail-analytics

## Key Skills/Techniques:
```SQL | Data Analysis | Window Functions | CTEs | Aggregation

# 🌟 If you find this project helpful, don’t forget to star the repo! 🌟
