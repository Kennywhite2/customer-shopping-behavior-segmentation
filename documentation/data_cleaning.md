# Data Cleaning and Feature Engineering

## Overview

The raw customer shopping dataset was prepared using Python and Pandas before being loaded into MySQL for SQL analysis and later visualized in Power BI.

The objective of this stage was to improve data quality, standardize inconsistent values, create useful analytical features, and prepare the dataset for reliable business analysis.

## Dataset Inspection

The raw CSV file was loaded into a Pandas DataFrame and inspected for:

* Dataset dimensions
* Column names
* Data types
* Missing values
* Duplicate records
* Descriptive statistics
* Inconsistent categorical values

The original dataset contained **3,900 customer records and 18 variables**.

## Missing Value Treatment

The `Review Rating` column contained **37 missing values**.

Instead of deleting these customer records, the missing values were replaced using the median review rating within the corresponding product category.

This approach preserved all 3,900 customer records while using category-level information to provide a more representative replacement value.

## Column Standardization

Column names were converted to lowercase `snake_case` format to improve consistency and make SQL querying easier.

For example:

```text
Purchase Amount (USD)
```

was renamed to:

```text
purchase_amount
```

## Age Group Feature Engineering

A new `age_group` variable was created to support demographic analysis.

Customers were grouped into:

* Young Adult
* Adult
* Middle-age
* Senior

This feature was later used to compare revenue, customer volume, average purchase value, and review ratings across age segments.

## Purchase Frequency Transformation

The original dataset stored purchase frequency as categorical values.

A new numerical variable called `purchase_frequency_days` was created to represent the approximate number of days between purchases.

| Purchase Frequency | Approximate Days |
| ------------------ | ---------------: |
| Weekly             |                7 |
| Bi-Weekly          |               14 |
| Monthly            |               30 |
| Quarterly          |               90 |
| Annually           |              365 |

## Purchase Frequency Standardization

The raw data contained categories that represented the same purchasing interval.

These included:

* `Fortnightly` and `Bi-Weekly`
* `Quarterly` and `Every 3 Months`

To improve consistency:

* `Fortnightly` was standardized to `Bi-Weekly`
* `Every 3 Months` was standardized to `Quarterly`

This reduced the purchase-frequency categories from seven inconsistent labels to five standardized groups without removing any customer records.

The final frequency distribution was:

| Purchase Frequency | Customers |
| ------------------ | --------: |
| Weekly             |       539 |
| Bi-Weekly          |     1,089 |
| Monthly            |       553 |
| Quarterly          |     1,147 |
| Annually           |       572 |

## Redundant Variable Removal

The following columns were compared:

```text
discount_applied
promo_code_used
```

The analysis showed that both variables contained equivalent information.

To reduce redundancy, the `promo_code_used` column was removed from the analytical dataset.

## Final Dataset

After cleaning and feature engineering, the prepared dataset contained:

* **3,900 customer records**
* **19 analytical variables**

No customer records were removed during the cleaning process.

## Loading Data into MySQL

The cleaned Pandas DataFrame was loaded into a MySQL database using Python database connectivity tools.

The prepared data was then used for SQL-based business analysis covering:

* Revenue performance
* Product categories
* Customer age groups
* Subscription behavior
* Discounts
* Shipping preferences
* Purchase frequency
* Payment methods

## Data Preparation Workflow

```text
Raw CSV
   ↓
Python / Pandas
   ↓
Data Inspection
   ↓
Missing Value Treatment
   ↓
Column Standardization
   ↓
Feature Engineering
   ↓
Category Standardization
   ↓
Redundant Variable Removal
   ↓
Data Validation
   ↓
MySQL Database
```

## Outcome

The data-cleaning stage transformed the raw customer dataset into a consistent and analysis-ready structure.

The cleaned dataset provided the foundation for the SQL analysis and Power BI dashboard used in the remaining stages of the project.
