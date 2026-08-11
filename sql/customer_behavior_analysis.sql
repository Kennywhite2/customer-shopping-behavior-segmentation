-- ============================================================
-- Customer Shopping Behavior Analysis
-- SQL Business Analysis
-- Database: customer_behavior
-- Table: customer
-- ============================================================

USE customer_behavior;

-- ============================================================
-- 1. DATA QUALITY CHECK
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM customer;


-- ============================================================
-- 2. OVERALL BUSINESS KPIs
-- ============================================================

SELECT
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(purchase_amount), 2) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS average_purchase_value,
    ROUND(AVG(review_rating), 2) AS average_review_rating,
    ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases
FROM customer;


-- ============================================================
-- 3. REVENUE BY PRODUCT CATEGORY
-- ============================================================

SELECT
    category,
    COUNT(*) AS total_purchases,
    SUM(purchase_amount) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS average_purchase_value
FROM customer
GROUP BY category
ORDER BY total_revenue DESC;


-- ============================================================
-- 4. CUSTOMER PERFORMANCE BY AGE GROUP
-- ============================================================

SELECT
    age_group,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(purchase_amount) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS average_purchase_value,
    ROUND(AVG(review_rating), 2) AS average_rating
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;


-- ============================================================
-- 5. SUBSCRIBERS VS NON-SUBSCRIBERS
-- ============================================================

SELECT
    subscription_status,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(purchase_amount) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS average_purchase_value,
    ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC;


-- ============================================================
-- 6. TOP 10 PRODUCTS BY REVENUE
-- ============================================================

SELECT
    item_purchased,
    COUNT(*) AS total_purchases,
    SUM(purchase_amount) AS total_revenue,
    ROUND(AVG(review_rating), 2) AS average_rating
FROM customer
GROUP BY item_purchased
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 7. SHIPPING METHOD ANALYSIS
-- ============================================================

SELECT
    shipping_type,
    COUNT(*) AS customers,
    ROUND(AVG(purchase_amount), 2) AS average_purchase_value,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY shipping_type
ORDER BY customers DESC;


-- ============================================================
-- 8. DISCOUNT IMPACT
-- ============================================================

SELECT
    discount_applied,
    COUNT(*) AS purchases,
    ROUND(AVG(purchase_amount), 2) AS average_purchase_value,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY discount_applied
ORDER BY total_revenue DESC;


-- ============================================================
-- 9. CUSTOMER PURCHASE FREQUENCY
-- ============================================================

SELECT
    frequency_of_purchases,
    COUNT(*) AS customers,
    ROUND(AVG(purchase_frequency_days), 2) AS average_frequency_days,
    ROUND(AVG(purchase_amount), 2) AS average_purchase_value
FROM customer
GROUP BY frequency_of_purchases
ORDER BY average_frequency_days;


-- ============================================================
-- 10. PAYMENT METHOD ANALYSIS
-- ============================================================

SELECT
    payment_method,
    COUNT(*) AS customers,
    SUM(purchase_amount) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS average_purchase_value
FROM customer
GROUP BY payment_method
ORDER BY total_revenue DESC;


-- ============================================================
-- 11. CATEGORY REVENUE RANKING AND CONTRIBUTION
-- CTE + WINDOW FUNCTIONS
-- ============================================================

WITH category_sales AS (
    SELECT
        category,
        COUNT(*) AS total_purchases,
        SUM(purchase_amount) AS total_revenue,
        ROUND(AVG(purchase_amount), 2) AS average_purchase_value
    FROM customer
    GROUP BY category
)

SELECT
    category,
    total_purchases,
    total_revenue,
    average_purchase_value,

    ROUND(
        100.0 * total_revenue /
        SUM(total_revenue) OVER (),
        2
    ) AS revenue_share_pct,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM category_sales
ORDER BY revenue_rank;


-- ============================================================
-- 12. TOP 3 PRODUCTS WITHIN EACH CATEGORY
-- CTE + PARTITIONED WINDOW FUNCTION
-- ============================================================

WITH product_sales AS (
    SELECT
        category,
        item_purchased,
        COUNT(*) AS total_purchases,
        SUM(purchase_amount) AS total_revenue,
        ROUND(AVG(purchase_amount), 2) AS average_purchase_value
    FROM customer
    GROUP BY category, item_purchased
),

ranked_products AS (
    SELECT
        category,
        item_purchased,
        total_purchases,
        total_revenue,
        average_purchase_value,

        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_revenue DESC
        ) AS product_rank

    FROM product_sales
)

SELECT
    category,
    item_purchased,
    total_purchases,
    total_revenue,
    average_purchase_value,
    product_rank
FROM ranked_products
WHERE product_rank <= 3
ORDER BY category, product_rank;


-- ============================================================
-- 13. CUSTOMER SPENDING SEGMENTATION
-- CTE + NTILE WINDOW FUNCTION
-- ============================================================

WITH customer_segments AS (
    SELECT
        customer_id,
        age_group,
        subscription_status,
        purchase_amount,
        previous_purchases,

        NTILE(4) OVER (
            ORDER BY purchase_amount
        ) AS spending_quartile

    FROM customer
)

SELECT
    CASE
        WHEN spending_quartile = 1 THEN 'Low Spend'
        WHEN spending_quartile = 2 THEN 'Lower-Mid Spend'
        WHEN spending_quartile = 3 THEN 'Upper-Mid Spend'
        WHEN spending_quartile = 4 THEN 'High Spend'
    END AS spending_segment,

    COUNT(*) AS customers,

    ROUND(
        AVG(purchase_amount),
        2
    ) AS average_purchase_value,

    MIN(purchase_amount) AS minimum_purchase,

    MAX(purchase_amount) AS maximum_purchase,

    ROUND(
        AVG(previous_purchases),
        2
    ) AS avg_previous_purchases

FROM customer_segments

GROUP BY spending_quartile

ORDER BY spending_quartile;


-- ============================================================
-- 14. SUBSCRIPTION RATE BY SPENDING SEGMENT
-- CTE + NTILE + CONDITIONAL AGGREGATION
-- ============================================================

WITH customer_segments AS (
    SELECT
        customer_id,
        purchase_amount,
        subscription_status,

        NTILE(4) OVER (
            ORDER BY purchase_amount
        ) AS spending_quartile

    FROM customer
)

SELECT
    CASE
        WHEN spending_quartile = 1 THEN 'Low Spend'
        WHEN spending_quartile = 2 THEN 'Lower-Mid Spend'
        WHEN spending_quartile = 3 THEN 'Upper-Mid Spend'
        WHEN spending_quartile = 4 THEN 'High Spend'
    END AS spending_segment,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN subscription_status = 'Yes' THEN 1
            ELSE 0
        END
    ) AS subscribers,

    SUM(
        CASE
            WHEN subscription_status = 'No' THEN 1
            ELSE 0
        END
    ) AS non_subscribers,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN subscription_status = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS subscription_rate_pct,

    ROUND(
        AVG(purchase_amount),
        2
    ) AS average_purchase_value

FROM customer_segments

GROUP BY spending_quartile
ORDER BY spending_quartile;