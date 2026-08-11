# Customer Shopping Behavior & Segmentation Analysis

## Project Overview

This end-to-end data analytics project analyzes customer shopping behavior to identify purchasing patterns, customer segments, product performance, subscription behavior, and revenue trends.

The project began with a raw customer shopping dataset containing 3,900 customer records. Python and Pandas were used in Jupyter Notebook for data inspection, cleaning, transformation, and feature engineering. The prepared dataset was then loaded into MySQL, where SQL queries were used to investigate customer behavior, revenue performance, product categories, subscription status, purchase frequency, shipping preferences, and payment methods.

The analyzed data was connected to Power BI, where DAX measures, KPIs, interactive visualizations, and customer segmentation were developed.

A customer segmentation model divides the 3,900 customers into four spending groups:

High Spender
Medium-High Spender
Medium-Low Spender
Low Spender

The final interactive Power BI dashboard allows users to analyze customer behavior using dynamic filters and provides actionable insights that can support customer targeting, marketing strategy, product decisions, and customer retention.

Project Workflow

Raw CSV → Python/Pandas → Data Cleaning & Feature Engineering → MySQL → SQL Analysis → Power BI → DAX & Customer Segmentation → Business Insights & Recommendations

## Dashboard Preview

![Customer Shopping Behavior & Segmentation Dashboard](Customer_Shopping_Behavior_Dashboard.jpg)

## Project Workflow

Raw CSV → Python/Pandas → Data Cleaning & Feature Engineering → MySQL → SQL Analysis → Power BI → DAX Segmentation → Business Insights

## Business Questions

The project investigates:

Which product categories and customer groups generate the most revenue?
How do subscription status and purchase frequency relate to customer behavior?
Which products, shipping methods, and payment methods perform best?
Do discounts correspond with higher customer spending?
How can customers be segmented based on their spending behavior?
Key KPIs
KPI	Result
Customers	3,900
Total Revenue	$233,081
Average Purchase Value	$59.76
Average Review Rating	3.75 / 5
Key Insights
Clothing was the strongest category, generating $104,264 in revenue.
Young Adults generated the highest age-group revenue at $62,143.
Only 1,053 of 3,900 customers were subscribers, highlighting a potential subscription-conversion opportunity.
Blouse was the highest-revenue individual product at $10,410.
Free Shipping was the most frequently selected shipping option.
Discounted transactions had a slightly lower average purchase value than non-discounted transactions.
Purchase frequency did not strongly determine the amount customers spent per transaction.
DAX-based segmentation was used to classify customers into High, Medium-High, Medium-Low, and Low Spenders.
Business Recommendations
Prioritize Clothing in merchandising and revenue-focused campaigns.
Target high-value customer segments with personalized offers and loyalty initiatives.
Test subscription-conversion strategies among active non-subscribers.
Review discount effectiveness before increasing promotional activity.
Use customer spending segments to support targeted marketing and retention strategies.
Monitor product performance using both revenue and customer ratings.
Tools Used

Python | Pandas | Jupyter Notebook | MySQL | SQL | SQLAlchemy | Power BI | Power Query | DAX | Git | GitHub

## Detailed Project Documentation

Detailed technical analysis is available inside the repository:

documentation/data_cleaning.md – Python/Pandas cleaning and feature engineering
documentation/sql_analysis.md – SQL queries and business analysis
documentation/business_insights.md – Detailed analytical findings
documentation/business_recommendations.md – Business interpretation and recommendations
Repository Structure
├── data/              # Raw/project dataset
├── notebook/          # Python cleaning and feature engineering
├── sql/               # MySQL business analysis
├── dashboard/         # Power BI dashboard files
├── documentation/     # Detailed project documentation
└── README.md
Project Outcome

This project demonstrates an end-to-end data analytics workflow by transforming raw customer data into structured analysis, an interactive Power BI dashboard, customer segmentation, and actionable business recommendations.
