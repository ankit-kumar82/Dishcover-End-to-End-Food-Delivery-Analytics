# 🚀 Dishcover – End-to-End Food Delivery Analytics (PostgreSQL & Power BI)

An end-to-end data analytics project that simulates a food delivery platform and analyzes customer behavior, restaurant performance, rider efficiency, delivery operations, and business growth using PostgreSQL and Power BI.

---

## 📌 Overview

Dishcover is a fictional food delivery platform created to demonstrate how SQL and Business Intelligence tools can be used to solve real-world business problems.

The project begins with designing a relational database in PostgreSQL, importing structured datasets, cleaning and validating data, and then performing analytical queries to answer important business questions. Finally, the insights are visualized through an interactive Power BI dashboard.

The name **Dishcover** combines the words **Dish** and **Discover**, representing the process of uncovering valuable insights from food delivery data.

This project simulates the workflow of a Data Analyst—from database design and data cleaning to business analysis and dashboard creation.

---

## 🎯 Project Objectives

* Design and manage a relational database using PostgreSQL
* Analyze customer ordering behavior
* Measure restaurant performance and revenue
* Evaluate rider delivery efficiency
* Identify customer churn and segmentation opportunities
* Track sales trends and seasonal demand
* Build an interactive Power BI dashboard for decision-making

---

## 🗂️ Project Highlights

✅ Created and managed a PostgreSQL database (`dishcover_db`)

✅ Designed normalized tables for:

* Customers
* Restaurants
* Orders
* Deliveries
* Riders

✅ Imported CSV datasets into PostgreSQL

✅ Performed data cleaning and handled missing values

✅ Solved 20 real-world business problems using SQL

✅ Used advanced SQL concepts:

* Joins
* CTEs
* Window Functions
* Aggregate Functions
* Subqueries
* CASE Statements
* Date & Time Functions

✅ Built an interactive Power BI dashboard

✅ Generated business insights from operational data

---

## 📚 What I Learned From This Project

Through Dishcover, I developed practical experience in:

* Database Design
* Data Cleaning
* Data Validation
* SQL Query Writing
* Data Analysis
* Business Problem Solving
* Dashboard Development
* Data Visualization

This project helped me understand how raw data can be transformed into actionable business insights.

<img width="635" height="360" alt="Screenshot 2026-06-23 170115" src="https://github.com/user-attachments/assets/39c309f7-460f-4656-8ddf-87ecf4b0a819" />


---

## 📊 Power BI Dashboard – Dishcover

To make the insights more interactive and visually appealing, I designed a Power BI dashboard using the Dishcover dataset. The dashboard transforms raw SQL outputs into meaningful business insights through charts, KPIs, filters, and interactive visualizations.

The dashboard provides a comprehensive view of business performance, helping stakeholders monitor sales, customer behavior, restaurant performance, delivery operations, and rider efficiency.

### 📸 Dashboard Preview

<img width="1448" height="1086" alt="descover" src="https://github.com/user-attachments/assets/173dab20-ed4a-44bc-9d6e-93ade44a59d6" />

 <img width="635" height="347" alt="Screenshot 2026-06-23 170023" src="https://github.com/user-attachments/assets/742383a5-7b2a-4434-bc63-4b4d3473c46a" />



### 🔍 Dashboard Highlights

* 💰 Total Revenue Analysis
* 📦 Total Orders and Deliveries
* 👥 Customer Insights
* 🍽️ Restaurant Performance Tracking
* 🚴 Rider Efficiency Monitoring
* 📈 Monthly Sales Trends
* 🏙️ City-wise Revenue Distribution
* ⭐ Customer Segmentation Analysis
* ❌ Order Cancellation Analysis
* ⏰ Order Time Slot Analysis

---

## 🛠️ Tools Used

| Tool       | Purpose                   |
| ---------- | ------------------------- |
| PostgreSQL | Database Management       |
| pgAdmin 4  | Database Administration   |
| SQL        | Data Analysis             |
| Power BI   | Dashboard & Visualization |
| CSV Files  | Data Source               |
| python     |  Data preprocessing and cleaning using Pandas  |

---

## 🧱 Database Structure

The project consists of five interconnected tables:

### customers

Stores customer information such as:

* Customer ID
* Customer Name
* Registration Date

### restaurants

Stores restaurant details such as:

* Restaurant ID
* Restaurant Name
* City
* Opening Hours

### orders

Stores order-related information:

* Order ID
* Customer ID
* Restaurant ID
* Order Item
* Order Date
* Order Time
* Order Status
* Total Amount

### deliveries

Stores delivery information:

* Delivery ID
* Order ID
* Rider ID
* Delivery Time
* Delivery Status

### riders

Stores rider details:

* Rider ID
* Rider Name
* Signup Date

---

## 🚀 How to Use This Project

### Step 1: Clone Repository

Download or clone this repository.

### Step 2: Create Database

Create a PostgreSQL database:

```sql
CREATE DATABASE dishcover_db;
```

### Step 3: Run Schema File

Execute:

```text
Dishcover_Schema.sql
```

to create all required tables.

### Step 4: Import CSV Files

Import data in the following order:

```text
customers.csv
restaurants.csv
orders.csv
riders.csv
deliveries.csv
```

### Step 5: Run SQL Queries

Execute:

```text
20 Business Problems solution.sql
```

to perform analysis.

### Step 6: Open Power BI Dashboard

Open the Power BI file:

```text
Dishcover_Dashboard.pbix
```

to explore interactive insights.

---

## 📁 Project Structure

```text
Dishcover/
│
├── data/
│   ├── customers.csv
│   ├── restaurants.csv
│   ├── orders.csv
│   ├── riders.csv
│   └── deliveries.csv
│
├── sql/
│   ├── Dishcover_Schema.sql
│   └── 20_Business_Problems_Solution.sql
│
├── dashboard/
│   ├── Dishcover_Dashboard.pbix
│   └── dashboard_screenshot.png
│
└── README.md
```

---

## 💡 Sample Business Problems Solved

### Customer Analytics

* Top 5 dishes ordered by a customer
* Customer Lifetime Value (CLV)
* Customer Segmentation
* Customer Churn Analysis

### Restaurant Analytics

* Top restaurants by revenue
* Restaurant growth analysis
* City-wise revenue ranking

### Delivery Analytics

* Orders not delivered
* Rider efficiency analysis
* Rider rating analysis

### Sales Analytics

* Monthly sales trends
* Revenue growth tracking
* Seasonal demand analysis

### Operational Analytics

* Popular order time slots
* Cancellation rate comparison
* Order frequency analysis

In total, the project solves **20 real-world business problems using SQL**.

---

## ✅ Conclusion

Dishcover helped me apply SQL concepts to realistic business scenarios and understand how data supports decision-making.

Through this project, I gained hands-on experience in:

* Relational Database Design
* Data Cleaning and Validation
* SQL Query Optimization
* Business Analysis
* Data Visualization
* Dashboard Development

By combining PostgreSQL and Power BI, I transformed raw transactional data into actionable insights that can help businesses improve customer retention, operational efficiency, and revenue growth.

---

## ⚠️ Disclaimer

This project was created for educational and portfolio purposes only.

All datasets used are fictional and generated for learning. The project is not affiliated with any real food delivery platform, company, or organization.

Any resemblance to real businesses or datasets is purely coincidental.

---

## 📊 Future Improvements

Planned enhancements include:

* Advanced Power BI dashboards
* Additional KPI tracking
* Customer retention forecasting
* Predictive analytics
* Tableau dashboard implementation
* Automated reporting workflows

---

## 👩‍💻 About Me

I am a final-year B.Tech Computer Science student passionate about Data Analytics, Business Intelligence, SQL, and Full-Stack Development.

This project allowed me to strengthen my skills in:

* Database Design
* SQL Development
* Data Analysis
* Business Intelligence
* Power BI Dashboarding
* Problem Solving



 
