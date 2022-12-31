-----------------------------------
-- Case Study #1 - Danny's Diner --
-----------------------------------

CREATE DATABASE dannys_diner;

USE dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

--------------------------
-- Case Study Questions --
--------------------------

-- 1. What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, 
       SUM(m.price) AS total_amount
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id;


-- 2. How many days has each customer visited the restaurant?
SELECT customer_id,
       COUNT(DISTINCT order_date) AS total_days_visited
FROM sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
SELECT customer_id,
	   product_name
FROM(SELECT s.customer_id,
			m.product_name,
			DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date, s.product_id) AS rnk
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id) AS temp_table
WHERE rnk = 1
GROUP BY customer_id, product_name;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT m.product_name AS most_purchased_item,
       COUNT(s.product_id) AS count
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY product_name
ORDER BY count DESC
LIMIT 1;


-- 5. Which item was the most popular for each customer?
WITH CTE_RANK AS(
SELECT s.customer_id,
	   m.product_name,
	   COUNT(*) as order_count,
	   DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(s.customer_id) DESC) AS rnk
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name)
SELECT customer_id,
	   product_name,
       order_count
FROM CTE_RANK
WHERE rnk = 1;


-- 6. Which item was purchased first by the customer after they became a member?
SELECT s.customer_id,
       m.product_name
FROM menu AS m
JOIN sales AS s ON m.product_id = s.product_id
JOIN members AS mem ON s.customer_id = mem.customer_id
WHERE s.order_date >= mem.join_date
GROUP BY customer_id
ORDER BY customer_id;


-- 7. Which item was purchased just before the customer became a member?
SELECT customer_id,
       GROUP_CONCAT(product_name) AS ordered_food
FROM (SELECT s.customer_id,
	     m.product_name,
             DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rnk
      FROM menu AS m
      JOIN sales AS s ON m.product_id = s.product_id
      JOIN members AS mem ON s.customer_id = mem.customer_id
      WHERE s.order_date< mem.join_date) AS temp_table
WHERE rnk = 1
GROUP BY customer_id;


-- 8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id,
	   COUNT(DISTINCT s.product_id) AS total_distinct_items,
	   SUM(m.price) AS total_amount
FROM menu AS m
JOIN sales AS s ON m.product_id = s.product_id
JOIN members AS mem ON s.customer_id = mem.customer_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;


-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
WITH CTE_Customer_Point AS 
(SELECT s.customer_id,
SUM(
	CASE 
		WHEN m.product_name = 'sushi' THEN (m.price * 20)
        ELSE m.price * 10
	END) AS total_points
FROM sales as s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY customer_id)
SELECT *
FROM CTE_Customer_Point;


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi 
-- how many points do customer A and B have at the end of January?
SELECT s.customer_id,
	   SUM(
			CASE
				WHEN m.product_name = 'sushi' THEN 20 * price
				WHEN order_date BETWEEN '2021-01-07' AND '2021-01-14' THEN 20 * price
				ELSE 10 * PRICE
			END
		  ) AS Points
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
JOIN members AS mem ON mem.customer_id = s.customer_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

---------------------
-- BONUS QUESTIONS --
---------------------

-- 1. Recreate the table output using the available data with : customer_id, order_date, product_name, price, member (Y/N)
SELECT s.customer_id,
	   s.order_date,
       m.product_name,
       m.price,
       CASE
	    WHEN mem.join_date > s.order_date THEN 'N'
            WHEN mem.join_date <= s.order_date THEN 'Y'
            ELSE 'N'
       END AS member
FROM menu AS m
LEFT JOIN sales AS s
ON s.product_id = m.product_id
LEFT JOIN members AS mem
ON s.customer_id = mem.customer_id
ORDER BY customer_id, order_date, product_name;


-- 2. Danny also requires further information about the ranking of customer products but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
WITH CTE_ranking AS
(SELECT s.customer_id,
	    s.order_date,
        m.product_name,
        m.price,
       CASE
			WHEN mem.join_date > s.order_date THEN 'N'
            WHEN mem.join_date <= s.order_date THEN 'Y'
            ELSE 'N'
		END AS member
FROM menu AS m
LEFT JOIN sales AS s
ON s.product_id = m.product_id
LEFT JOIN members AS mem
ON s.customer_id = mem.customer_id
ORDER BY customer_id, order_date, product_name)
SELECT *,
		CASE
			WHEN member = 'N' THEN null
            ELSE RANK() OVER(PARTITION BY customer_id, member ORDER BY order_date) 
		END AS ranking
FROM CTE_Ranking;