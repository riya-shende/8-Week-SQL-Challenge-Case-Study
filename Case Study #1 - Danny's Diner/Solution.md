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

#

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

#

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

````sql
SELECT m.product_name AS most_purchased_item,
       COUNT(s.product_id) AS count
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY product_name
ORDER BY count DESC
LIMIT 1;
````

#### Output :
| most_purchased_item | count |
| ------------------- | ----- |
| ramen               | 8     |


- Most purchased item on the menu is ramen and it was purchased 8 times by all the customers. Yummy!

#

### 5. Which item was the most popular for each customer?

#

### 6. Which item was purchased first by the customer after they became a member?

````sql
SELECT s.customer_id,
	   m.product_name
FROM menu AS m
JOIN sales AS s ON m.product_id = s.product_id
JOIN members AS mem ON s.customer_id = mem.customer_id
WHERE s.order_date >= mem.join_date
GROUP BY customer_id
ORDER BY customer_id;
````

#### Output : 
| customer_id | product_name |
| ----------- | ------------ |
| A | curry |
| B | sushi |

- Customer A's first order after becoming the member was curry.
- Customer B's first order after becoming the member was sushi.

#

### 7. Which item was purchased just before the customer became a member?

````sql
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
````

#### Output :
| customer_id | ordered_food |
| ----------- | ------------ |
| A | sushi, curry |
| B | sushi |

- Customer A’s last order before becoming a member was sushi and curry.
- Customer B's last order before becoming a member was sushi.

#

### 8. What is the total items and amount spent for each member before they became a member?

````sql
SELECT s.customer_id,
	   COUNT(DISTINCT s.product_id) AS total_distinct_items,
	   SUM(m.price) AS total_amount
FROM menu AS m
JOIN sales AS s ON m.product_id = s.product_id
JOIN members AS mem ON s.customer_id = mem.customer_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
````

#### Output :
| customer_id |	total_distinct_items | total_amount |
| ----------- | -------------------- | ------------ |
| A | 2 | 25 |
| B | 3 | 40 |

- Before becoming members, Customer A spent $25 on 2 items.
- Before becoming members, Customer B spent $40 on 2 items.
