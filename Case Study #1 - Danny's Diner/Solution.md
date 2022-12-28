# SOLUTION

### 1. What is the total amount each customer spent at the restaurant?

````sql
SELECT s.customer_id, 
       SUM(m.price) AS total_amount
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id;
````

### Output :

| customer_id | total_amount |
| ----------- | ------------ |
| A           | 76           |
| B           | 74           |
| C           | 36           |

- Customer A spent $76.
- Customer B spent $74.
- Customer C spent $36.

### 2. How many days has each customer visited the restaurant?

````sql
SELECT customer_id,
       COUNT(DISTINCT order_date) AS total_days_visited
FROM sales
GROUP BY customer_id;
````
#### Output :

| customer_id | total_days_visited |
| ----------- | ------------------ |
| A           | 4                  |
| B           | 6                  |
| C           | 2                  |

- Customer A visited 4 times.
- Customer B visited 6 times.
- Customer C visited 2 times.

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

````sql
SELECT COUNT(s.product_id) AS count,
	m.product_name AS most_purchased_item
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY product_name
ORDER BY count DESC
LIMIT 1;
````

#### Output :
| count | most_purchased_item | 
| ----- | ------------------- |
| 8     | ramen               |


- Most purchased item on the menu is ramen and it was purchased 8 times by all the customers. Yummy!
