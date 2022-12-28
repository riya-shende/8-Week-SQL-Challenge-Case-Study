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

### Output:

| customer_id | total_amount |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

- Customer A spent $76.
- Customer B spent $74.
- Customer C spent $36.
