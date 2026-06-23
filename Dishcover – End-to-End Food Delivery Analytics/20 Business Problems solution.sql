-- Dishcover: 20 Real-World SQL Business Problem Solutions

SELECT * FROM customers;
SELECT * FROM restaurants;
SELECT * FROM orders;
SELECT * FROM riders;
SELECT * FROM deliveries;

-- Handling NULL VALUES

SELECT COUNT(*)
FROM customers
WHERE customer_name IS NULL
   OR reg_date IS NULL;

SELECT COUNT(*)
FROM restaurants
WHERE restaurant_name IS NULL
   OR city IS NULL
   OR opening_hours IS NULL;

SELECT *
FROM orders
WHERE order_item IS NULL
   OR order_date IS NULL
   OR order_time IS NULL
   OR order_status IS NULL
   OR total_amount IS NULL;

DELETE FROM orders
WHERE order_item IS NULL
   OR order_date IS NULL
   OR order_time IS NULL
   OR order_status IS NULL
   OR total_amount IS NULL;

-- -------------------------
-- Analysis & Reports
-- -------------------------


-- Q.1
-- Write a query to find the top 5 most frequently ordered dishes by customer called "Arjun Mehta" in the last 1 year.
-- 

-- join cx and orders
-- filter for last 1 year 
-- FILTER 'arjun mehta'
-- group by cx id, dishes, cnt
SELECT 
    customer_name,
    dishes,
    total_orders
FROM
(
    SELECT 
        c.customer_id,
        c.customer_name,
        o.order_item AS dishes,
        COUNT(*) AS total_orders,
        DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS rank
    FROM orders o
    JOIN customers c
        ON c.customer_id = o.customer_id
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 year'
      AND c.customer_name = 'Arjun Mehta'
    GROUP BY 1,2,3
) t1
WHERE rank <= 5;
SELECT *
FROM customers
WHERE customer_name = 'Arjun Mehta';
SELECT COUNT(*)
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id
WHERE c.customer_name = 'Arjun Mehta';
SELECT
    customer_name,
    dishes,
    total_orders
FROM
(
    SELECT
        c.customer_id,
        c.customer_name,
        o.order_item AS dishes,
        COUNT(*) AS total_orders,
        DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS rank
    FROM orders o
    JOIN customers c
        ON c.customer_id = o.customer_id
    WHERE c.customer_name = 'Arjun Mehta'
    GROUP BY 1,2,3
) t1
WHERE rank <= 5;
-- Q2. Popular Time Slots
-- Identify the time slots during which the most orders are placed based on 2-hour intervals

SELECT
    FLOOR(EXTRACT(HOUR FROM order_time)/2)*2 AS start_time,
    FLOOR(EXTRACT(HOUR FROM order_time)/2)*2 + 2 AS end_time,
    COUNT(*) AS total_orders
FROM orders
GROUP BY 1,2
ORDER BY 3 DESC;

-- Q3. Order Value Analysis
-- Find the average order value per customer who has placed more than 750 orders

SELECT
    c.customer_name,
    AVG(o.total_amount) AS aov
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 750
ORDER BY aov DESC;

-- Q4. High-Value Customers
-- List customers who have spent more than 100K in total on food orders

SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) > 100000
ORDER BY total_spent DESC;
  
  -- Question 5

-- Find orders that were placed but not delivered.
-- Simple Language

-- Customer ne order place kar diya ✅

-- Lekin delivery table me us order ka record nahi hai ❌

-- Matlab order hua tha, par deliver nahi hua.

-- Kya Return Karna Hai?
-- Restaurant Name
-- Number of Not Delivered Orders
SELECT
    r.restaurant_name,
    COUNT(o.order_id) AS cnt_not_delivered_orders
FROM orders o
LEFT JOIN restaurants r
    ON r.restaurant_id = o.restaurant_id
LEFT JOIN deliveries d
    ON d.order_id = o.order_id
WHERE d.delivery_id IS NULL
GROUP BY r.restaurant_name
ORDER BY cnt_not_delivered_orders DESC;


-- Q6 ye keh raha hai: pichle 1 saal me har city ke andar restaurants ko unki total revenue ke basis pe rank karo. Is query me har restaurant ki pichle 1 saal ki total kamai nikal ke, city-wise unko rank de raha hai. Aur last me sirf rank 1 wale dikhaye ja rahe hain. Matlab har city ka top earning restaurant.
-- Q6. Restaurant Revenue Ranking
-- Rank restaurants by total revenue and find the top restaurant in each city

WITH ranking_table AS
(
    SELECT
        r.city,
        r.restaurant_name,
        SUM(o.total_amount) AS revenue,
        RANK() OVER
        (
            PARTITION BY r.city
            ORDER BY SUM(o.total_amount) DESC
        ) AS rank
    FROM orders o
    JOIN restaurants r
        ON r.restaurant_id = o.restaurant_id
    GROUP BY r.city, r.restaurant_name
)

SELECT *
FROM ranking_table
WHERE rank = 1;

-- Q7. Most Popular Dish by City
-- Identify the most popular dish in each city based on the number of orders

SELECT *
FROM
(
    SELECT
        r.city,
        o.order_item AS dish,
        COUNT(o.order_id) AS total_orders,
        RANK() OVER
        (
            PARTITION BY r.city
            ORDER BY COUNT(o.order_id) DESC
        ) AS rank
    FROM orders o
    JOIN restaurants r
        ON r.restaurant_id = o.restaurant_id
    GROUP BY r.city, o.order_item
) t1
WHERE rank = 1;

-- Question 8 – Customer Churn

-- Find customers who haven’t placed an order in 2024 but did in 2023.
-- Q8. Customer Churn

-- Q8 Customer Churn with Customer Name

SELECT DISTINCT
    c.customer_id,
    c.customer_name
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2023
  AND c.customer_id NOT IN
(
    SELECT DISTINCT customer_id
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 2024
);


-- Question 9

-- Calculate and compare the order cancellation rate for each restaurant between the current year (2024) and previous year (2023).
-- Q9. Cancellation Rate Comparison
-- Compare cancellation rate of each restaurant between 2023 and 2024

WITH cancel_ratio_23 AS
(
    SELECT
        o.restaurant_id,
        COUNT(o.order_id) AS total_orders,
        COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS not_delivered
    FROM orders o
    LEFT JOIN deliveries d
        ON o.order_id = d.order_id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2023
    GROUP BY o.restaurant_id
),

cancel_ratio_24 AS
(
    SELECT
        o.restaurant_id,
        COUNT(o.order_id) AS total_orders,
        COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS not_delivered
    FROM orders o
    LEFT JOIN deliveries d
        ON o.order_id = d.order_id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2024
    GROUP BY o.restaurant_id
),

last_year_data AS
(
    SELECT
        restaurant_id,
        ROUND(
            (not_delivered::NUMERIC / total_orders::NUMERIC) * 100,
            2
        ) AS cancel_ratio
    FROM cancel_ratio_23
),

current_year_data AS
(
    SELECT
        restaurant_id,
        ROUND(
            (not_delivered::NUMERIC / total_orders::NUMERIC) * 100,
            2
        ) AS cancel_ratio
    FROM cancel_ratio_24
)

SELECT
    r.restaurant_name,
    c.cancel_ratio AS current_year_cancel_ratio,
    l.cancel_ratio AS last_year_cancel_ratio
FROM current_year_data c
JOIN last_year_data l
    ON c.restaurant_id = l.restaurant_id
JOIN restaurants r
    ON r.restaurant_id = c.restaurant_id
ORDER BY r.restaurant_name;

-- Q10 ka question hai:

-- Determine each rider's average delivery time.

-- Simple Language

-- Har rider ko order deliver karne me average kitna time lagta hai?

-- Example:

-- Rider 1 → 18 min average
-- Rider 2 → 22 min average
-- Rider 3 → 15 min average
-- Q10. Rider Average Delivery Time

SELECT
    d.rider_id,
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (
                d.delivery_time - o.order_time +
                CASE
                    WHEN d.delivery_time < o.order_time
                    THEN INTERVAL '1 day'
                    ELSE INTERVAL '0 day'
                END
            )) / 60
        ),
        2
    ) AS avg_delivery_time_minutes
FROM orders o
JOIN deliveries d
    ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered'
GROUP BY d.rider_id
ORDER BY avg_delivery_time_minutes;

-- Question 11

-- Calculate each restaurant's monthly growth ratio based on delivered orders.

-- Simple Language

-- Har restaurant ke liye:

-- Pichhle month kitne delivered orders the?
-- Current month kitne delivered orders hain?
-- Growth kitni hui?
-- Q11 Monthly Restaurant Growth Ratio

WITH growth_ratio AS
(
    SELECT
        o.restaurant_id,
        EXTRACT(YEAR FROM o.order_date) AS year,
        EXTRACT(MONTH FROM o.order_date) AS month,
        COUNT(o.order_id) AS cr_month_orders,
        LAG(COUNT(o.order_id))
        OVER
        (
            PARTITION BY o.restaurant_id
            ORDER BY
                EXTRACT(YEAR FROM o.order_date),
                EXTRACT(MONTH FROM o.order_date)
        ) AS prev_month_orders
    FROM orders o
    JOIN deliveries d
        ON o.order_id = d.order_id
    WHERE d.delivery_status = 'Delivered'
    GROUP BY 1,2,3
)

SELECT
    restaurant_id,
    year,
    month,
    prev_month_orders,
    cr_month_orders,
    ROUND(
        ((cr_month_orders - prev_month_orders)::NUMERIC
        / NULLIF(prev_month_orders,0)) * 100,
        2
    ) AS growth_ratio
FROM growth_ratio;


-- Question 12 – Customer Segmentation

-- Customers ko 2 groups me baantna hai:

-- Gold Customer

-- Agar customer ka total spending:

-- Customer Total Spend > Average Order Value (AOV)

-- to Gold.

-- Silver Customer

-- Agar customer ka total spending:

-- Customer Total Spend <= Average Order Value (AOV)

-- to Silver.
-- Q12 Customer Segmentation

SELECT
    cx_category,
    SUM(total_orders) AS total_orders,
    SUM(total_spent) AS total_revenue
FROM
(
    SELECT
        customer_id,
        SUM(total_amount) AS total_spent,
        COUNT(order_id) AS total_orders,
        CASE
            WHEN SUM(total_amount) >
                 (SELECT AVG(total_amount) FROM orders)
            THEN 'Gold'
            ELSE 'Silver'
        END AS cx_category
    FROM orders
    GROUP BY customer_id
) t1
GROUP BY cx_category;


-- Question 13

-- Calculate each rider's total monthly earnings, assuming they earn 8% of the order amount.

-- Simple Language

-- Har rider ke liye:

-- Ek month me kitne orders deliver kiye?
-- Un orders ki total value kitni thi?
-- Us total value ka 8% rider ki earning hai.
-- Q13 Rider Monthly Earnings

SELECT
    d.rider_id,
    TO_CHAR(o.order_date, 'MM-YY') AS month,
    SUM(o.total_amount) AS revenue,
    ROUND(SUM(o.total_amount) * 0.08, 2) AS rider_earning
FROM orders o
JOIN deliveries d
    ON o.order_id = d.order_id
GROUP BY d.rider_id, TO_CHAR(o.order_date, 'MM-YY')
ORDER BY d.rider_id, month;


-- Question 14 – Rider Ratings Analysis

-- Riders ko rating deni hai based on delivery time.

-- Rating Rules

-- ✅ 5 Star

-- Delivery Time < 15 minutes

-- ✅ 4 Star

-- Delivery Time between 15 and 20 minutes

-- ✅ 3 Star

-- Delivery Time > 20 minutes
-- Example
-- Delivery Time	Rating
-- 12 min	5 Star
-- 18 min	4 Star
-- 25 min	3 Star
-- Q14 Rider Ratings Analysis

SELECT
    rider_id,
    stars,
    COUNT(*) AS total_stars
FROM
(
    SELECT
        rider_id,
        CASE
            WHEN delivery_took_time < 15 THEN '5 Star'
            WHEN delivery_took_time BETWEEN 15 AND 20 THEN '4 Star'
            ELSE '3 Star'
        END AS stars
    FROM
    (
        SELECT
            d.rider_id,
            EXTRACT(
                EPOCH FROM
                (
                    d.delivery_time - o.order_time +
                    CASE
                        WHEN d.delivery_time < o.order_time
                        THEN INTERVAL '1 day'
                        ELSE INTERVAL '0 day'
                    END
                )
            ) / 60 AS delivery_took_time
        FROM orders o
        JOIN deliveries d
            ON o.order_id = d.order_id
        WHERE d.delivery_status = 'Delivered'
    ) t1
) t2
GROUP BY rider_id, stars
ORDER BY rider_id, total_stars DESC;

-- Question 15
-- Analyze order frequency per day of the week and identify the peak day for each restaurant.

-- Simple Language

-- Har restaurant ke liye dekhna hai:

-- Monday ko kitne orders aaye?
-- Tuesday ko kitne orders aaye?
-- Wednesday ko kitne orders aaye?
-- ...
-- Sunday ko kitne orders aaye?

-- Phir pata lagana hai:

-- 👉 Kaunsa day us restaurant ke liye sabse busy tha?
-- Q15 Order Frequency by Day

SELECT *
FROM
(
    SELECT
        r.restaurant_name,
        TO_CHAR(o.order_date, 'Day') AS day,
        COUNT(o.order_id) AS total_orders,
        RANK() OVER
        (
            PARTITION BY r.restaurant_name
            ORDER BY COUNT(o.order_id) DESC
        ) AS rank
    FROM orders o
    JOIN restaurants r
        ON o.restaurant_id = r.restaurant_id
    GROUP BY r.restaurant_name, TO_CHAR(o.order_date, 'Day')
) t1
WHERE rank = 1;



-- Question 16

-- Customer Lifetime Value (CLV)

-- Simple Language

-- Har customer ne company ko total kitna revenue diya hai?

-- Matlab:

-- Customer Lifetime Value (CLV)
-- =
-- Customer ka total spending
-- =
-- Uske saare orders ka total amount
-- Q16 Customer Lifetime Value (CLV)

SELECT
    o.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS clv
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
ORDER BY clv DESC;


-- Question 17

-- Identify sales trends by comparing each month's total sales to the previous month.

-- Simple Language

-- Har month ki sales nikalo aur compare karo:

-- Is month kitni sales hui?
-- Pichhle month kitni sales hui?
-- Sales badhi ya kam hui?
-- Q17 Monthly Sales Trends

SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(total_amount) AS total_sales,
    LAG(SUM(total_amount),1)
    OVER(
        ORDER BY
        EXTRACT(YEAR FROM order_date),
        EXTRACT(MONTH FROM order_date)
    ) AS previous_month_sales
FROM orders
GROUP BY
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date);


-- 	Question 18

-- Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest averages.

-- Simple Language

-- Har rider ke liye:

-- Average delivery time nikalo.
-- Kaunsa rider sabse fast hai? (lowest average time)
-- Kaunsa rider sabse slow hai? (highest average time)
-- Q18 Rider Efficiency

WITH new_table AS
(
    SELECT
        d.rider_id,
        EXTRACT(
            EPOCH FROM
            (
                d.delivery_time - o.order_time +
                CASE
                    WHEN d.delivery_time < o.order_time
                    THEN INTERVAL '1 day'
                    ELSE INTERVAL '0 day'
                END
            )
        ) / 60 AS time_deliver
    FROM orders o
    JOIN deliveries d
        ON o.order_id = d.order_id
    WHERE d.delivery_status = 'Delivered'
),

riders_time AS
(
    SELECT
        rider_id,
        AVG(time_deliver) AS avg_time
    FROM new_table
    GROUP BY rider_id
)

SELECT
    MIN(avg_time) AS fastest_avg_delivery_time,
    MAX(avg_time) AS slowest_avg_delivery_time
FROM riders_time;


-- Question 19

-- Track the popularity of specific order items over time and identify seasonal demand spikes.

-- Simple Language

-- Hume dekhna hai:

-- Kaunsi dish kis season me zyada order hui?
-- Kis season me demand spike hui?
-- Kaunsi dish summer me famous hai?
-- Kaunsi winter me zyada bikti hai?
-- Q19 Order Item Popularity

SELECT
    order_item,
    seasons,
    COUNT(order_id) AS total_orders
FROM
(
    SELECT
        order_id,
        order_item,
        CASE
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 4 AND 6
                THEN 'Spring'
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 7 AND 8
                THEN 'Summer'
            ELSE 'Winter'
        END AS seasons
    FROM orders
) t1
GROUP BY order_item, seasons
ORDER BY order_item, total_orders DESC;


-- Question 20

-- Rank each city based on total revenue for 2023.

-- Simple Language

-- Hume dekhna hai:

-- Har city ne kitna revenue generate kiya?
-- Sabse zyada revenue wali city kaunsi hai?
-- Sabse kam revenue wali city kaunsi hai?

-- Aur phir cities ko rank deni hai.

-- Example
-- City	Revenue
-- Mumbai	₹8,50,000
-- Delhi	₹7,20,000
-- Pune	₹5,10,000

-- Result:

-- Mumbai → Rank 1
-- Delhi  → Rank 2
-- Pune   → Rank 3
-- Q20 Rank Cities by Revenue (2023)

SELECT
    r.city,
    SUM(o.total_amount) AS total_revenue,
    RANK() OVER
    (
        ORDER BY SUM(o.total_amount) DESC
    ) AS city_rank
FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2023
GROUP BY r.city;

-- End of Reports