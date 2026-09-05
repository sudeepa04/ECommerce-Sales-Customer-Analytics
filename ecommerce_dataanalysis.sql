/* ============================================================
   E-COMMERCE SALES & CUSTOMER ANALYTICS
   Database: ecommerce_analytics
   Dataset: Olist Brazilian E-Commerce Public Dataset

   Tools:
   MySQL

   SQL Concepts Used:
   SELECT, WHERE, GROUP BY, ORDER BY, JOIN, CASE WHEN,
   Aggregate Functions, HAVING, Subqueries, CTEs,
   Window Functions
   ============================================================ */


/* ============================================================
   1. DATABASE SETUP
   ============================================================ */

CREATE DATABASE IF NOT EXISTS ecommerce_analytics;

USE ecommerce_analytics;


/* ============================================================
   2. TABLE CREATION
   ============================================================ */


/* -------------------------
   Orders
   ------------------------- */

CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);


/* -------------------------
   Customers
   ------------------------- */

CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);


/* -------------------------
   Products
   ------------------------- */

CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(10,2),
    product_length_cm DECIMAL(10,2),
    product_height_cm DECIMAL(10,2),
    product_width_cm DECIMAL(10,2)
);


/* -------------------------
   Sellers
   ------------------------- */

CREATE TABLE IF NOT EXISTS sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);


/* -------------------------
   Order Items
   ------------------------- */

CREATE TABLE IF NOT EXISTS order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);


/* -------------------------
   Payments
   ------------------------- */

CREATE TABLE IF NOT EXISTS payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);


/* -------------------------
   Reviews
   ------------------------- */

CREATE TABLE IF NOT EXISTS reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);


/* ============================================================
   3. BASIC DATA VALIDATION
   ============================================================ */


/* Check number of records in each table */

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT COUNT(*) AS total_payments
FROM payments;

SELECT COUNT(*) AS total_reviews
FROM reviews;


/* Check order date range */

SELECT
    MIN(order_purchase_timestamp) AS earliest_order,
    MAX(order_purchase_timestamp) AS latest_order
FROM orders;


/* Check review date range */

SELECT
    MIN(review_creation_date) AS earliest_review,
    MAX(review_creation_date) AS latest_review
FROM reviews;


/* ============================================================
   4. ORDER ANALYSIS
   ============================================================ */


/* Order status distribution */

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


/* Orders by year */

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;


/* Orders by month */

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


/* ============================================================
   5. SALES / REVENUE ANALYSIS
   ============================================================ */


/* Total revenue */

SELECT
    ROUND(SUM(price), 2) AS total_revenue
FROM order_items;


/* Total freight value */

SELECT
    ROUND(SUM(freight_value), 2) AS total_freight
FROM order_items;


/* Total number of orders */

SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


/* Total items sold */

SELECT
    COUNT(*) AS items_sold
FROM order_items;


/* Average Order Value */

SELECT
    ROUND(
        SUM(price) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;


/* Monthly revenue */

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


/* Monthly revenue and order count */

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


/* ============================================================
   6. CATEGORY ANALYSIS
   ============================================================ */


/* Revenue by product category */

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;


/* Top 10 categories by revenue */

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;


/* Units sold by category */

SELECT
    p.product_category_name,
    COUNT(*) AS units_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY units_sold DESC;


/* Top 10 categories by units sold */

SELECT
    p.product_category_name,
    COUNT(*) AS units_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY units_sold DESC
LIMIT 10;


/* ============================================================
   7. PRODUCT ANALYSIS
   ============================================================ */


/* Top 10 products by revenue */

SELECT
    oi.product_id,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY revenue DESC
LIMIT 10;


/* Top products by number of items sold */

SELECT
    oi.product_id,
    COUNT(*) AS units_sold
FROM order_items oi
GROUP BY oi.product_id
ORDER BY units_sold DESC
LIMIT 10;


/* ============================================================
   8. CUSTOMER ANALYSIS
   ============================================================ */


/* Unique customers */

SELECT
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;


/* Customers by state */

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customers
GROUP BY customer_state
ORDER BY customers DESC;


/* Revenue by customer */

SELECT
    c.customer_unique_id,
    ROUND(SUM(oi.price), 2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY revenue DESC;


/* Top 10 customers by revenue */

SELECT
    c.customer_unique_id,
    ROUND(SUM(oi.price), 2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY revenue DESC
LIMIT 10;


/* ============================================================
   9. CUSTOMER RETENTION / REPEAT PURCHASE ANALYSIS
   ============================================================ */


/* Number of orders placed by each customer */

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY order_count DESC;


/* One-time vs repeat customers */

SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time'
        WHEN order_count BETWEEN 2 AND 3 THEN 'Repeat'
        ELSE 'Loyal'
    END AS customer_segment,
    COUNT(*) AS customers
FROM
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders
GROUP BY
    CASE
        WHEN order_count = 1 THEN 'One-time'
        WHEN order_count BETWEEN 2 AND 3 THEN 'Repeat'
        ELSE 'Loyal'
    END
ORDER BY customers DESC;


/* Repeat customers only */

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) >= 2
ORDER BY order_count DESC;


/* ============================================================
   10. PAYMENT ANALYSIS
   ============================================================ */


/* Payment method distribution */

SELECT
    payment_type,
    COUNT(*) AS transactions,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


/* Average payment value by payment method */

SELECT
    payment_type,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments
GROUP BY payment_type
ORDER BY average_payment_value DESC;


/* Credit card installment distribution */

SELECT
    payment_installments,
    COUNT(*) AS transactions
FROM payments
WHERE payment_type = 'credit_card'
GROUP BY payment_installments
ORDER BY payment_installments;


/* Maximum number of installments */

SELECT
    MAX(payment_installments) AS maximum_installments
FROM payments;


/* ============================================================
   11. DELIVERY PERFORMANCE
   ============================================================ */


/* Delivery status using CASE WHEN */

SELECT
    CASE
        WHEN order_delivered_customer_date IS NULL
            THEN 'Not Delivered'

        WHEN order_delivered_customer_date
             <= order_estimated_delivery_date
            THEN 'On Time'

        ELSE 'Late'
    END AS delivery_status,

    COUNT(*) AS total_orders

FROM orders

GROUP BY
    CASE
        WHEN order_delivered_customer_date IS NULL
            THEN 'Not Delivered'

        WHEN order_delivered_customer_date
             <= order_estimated_delivery_date
            THEN 'On Time'

        ELSE 'Late'
    END

ORDER BY total_orders DESC;


/* On-time delivery percentage */

SELECT
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN order_delivered_customer_date IS NOT NULL
                 AND order_delivered_customer_date
                     <= order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN order_delivered_customer_date IS NOT NULL
                    THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS on_time_delivery_percentage
FROM orders;


/* Average delivery time */

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


/* ============================================================
   12. CUSTOMER SATISFACTION / REVIEW ANALYSIS
   ============================================================ */


/* Review score distribution */

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;


/* Average review score */

SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews;


/* Review score by delivery status */

SELECT
    CASE
        WHEN o.order_delivered_customer_date IS NULL
            THEN 'Not Delivered'

        WHEN o.order_delivered_customer_date
             <= o.order_estimated_delivery_date
            THEN 'On Time'

        ELSE 'Late'
    END AS delivery_status,

    ROUND(AVG(r.review_score), 2) AS average_review_score,

    COUNT(r.review_id) AS total_reviews

FROM orders o

JOIN reviews r
    ON o.order_id = r.order_id

GROUP BY
    CASE
        WHEN o.order_delivered_customer_date IS NULL
            THEN 'Not Delivered'

        WHEN o.order_delivered_customer_date
             <= o.order_estimated_delivery_date
            THEN 'On Time'

        ELSE 'Late'
    END

ORDER BY average_review_score DESC;


/* ============================================================
   13. REVENUE BY CUSTOMER STATE
   ============================================================ */

SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;


/* ============================================================
   14. SELLER ANALYSIS
   ============================================================ */


/* Top sellers by revenue */

SELECT
    oi.seller_id,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY revenue DESC
LIMIT 10;


/* Top sellers by number of items sold */

SELECT
    oi.seller_id,
    COUNT(*) AS items_sold
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY items_sold DESC
LIMIT 10;


/* ============================================================
   15. ABOVE-AVERAGE CUSTOMER ANALYSIS
   ============================================================ */


/*
   Find customers whose revenue is greater than
   the average customer revenue.
*/

SELECT
    customer_unique_id,
    revenue
FROM
(
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
) AS customer_revenue
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM
    (
        SELECT
            c.customer_unique_id,
            SUM(oi.price) AS revenue
        FROM customers c
        JOIN orders o
            ON c.customer_id = o.customer_id
        JOIN order_items oi
            ON o.order_id = oi.order_id
        GROUP BY c.customer_unique_id
    ) AS avg_customer_revenue
)
ORDER BY revenue DESC;


/* ============================================================
   16. CTE - TOP CUSTOMERS
   ============================================================ */


/*
   Use a Common Table Expression to calculate
   customer revenue.
*/

WITH customer_revenue AS
(
    SELECT
        c.customer_unique_id,
        ROUND(SUM(oi.price), 2) AS revenue

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    revenue
FROM customer_revenue
ORDER BY revenue DESC
LIMIT 10;


/* ============================================================
   17. WINDOW FUNCTION - CUSTOMER RANKING
   ============================================================ */


/*
   Rank customers based on total revenue.
*/

WITH customer_revenue AS
(
    SELECT
        c.customer_unique_id,
        ROUND(SUM(oi.price), 2) AS revenue

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    revenue,
    RANK() OVER (
        ORDER BY revenue DESC
    ) AS customer_rank

FROM customer_revenue

ORDER BY customer_rank;


/* ============================================================
   18. CATEGORY RANKING
   ============================================================ */


/*
   Rank product categories based on revenue.
*/

WITH category_revenue AS
(
    SELECT
        p.product_category_name,
        ROUND(SUM(oi.price), 2) AS revenue

    FROM products p

    JOIN order_items oi
        ON p.product_id = oi.product_id

    GROUP BY p.product_category_name
)

SELECT
    product_category_name,
    revenue,
    RANK() OVER (
        ORDER BY revenue DESC
    ) AS category_rank

FROM category_revenue

ORDER BY category_rank;


/* ============================================================
   19. CUSTOMER ORDER SEGMENTATION USING CTE
   ============================================================ */

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    order_count,

    CASE
        WHEN order_count = 1
            THEN 'One-time'

        WHEN order_count BETWEEN 2 AND 3
            THEN 'Repeat'

        ELSE 'Loyal'
    END AS customer_segment

FROM customer_orders

ORDER BY order_count DESC;


/* ============================================================
   20. CUSTOMER SEGMENT SUMMARY
   ============================================================ */

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_unique_id
)

SELECT
    CASE
        WHEN order_count = 1
            THEN 'One-time'

        WHEN order_count BETWEEN 2 AND 3
            THEN 'Repeat'

        ELSE 'Loyal'
    END AS customer_segment,

    COUNT(*) AS customer_count

FROM customer_orders

GROUP BY
    CASE
        WHEN order_count = 1
            THEN 'One-time'

        WHEN order_count BETWEEN 2 AND 3
            THEN 'Repeat'

        ELSE 'Loyal'
    END

ORDER BY customer_count DESC;


/* ============================================================
   21. BUSINESS SUMMARY QUERIES
   ============================================================ */


/* Overall business KPIs */

SELECT

    ROUND(SUM(oi.price), 2) AS total_revenue,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT c.customer_unique_id) AS unique_customers,

    COUNT(oi.order_id) AS items_sold,

    ROUND(
        SUM(oi.price) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id

JOIN customers c
    ON o.customer_id = c.customer_id;


/* ============================================================
   END OF ANALYSIS
   ============================================================ */