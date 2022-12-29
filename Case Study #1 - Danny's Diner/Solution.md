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
### Approach 
- Use SUM aggregate function to calculate total amount spent by each customer at the restaurant.
- Use JOIN clause because customer_id is from sales table and price is from menu table.
- And lastly, use GROUP BY clause to group the result set by customer_id column.

### Output 
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
### Approach
- Use DISTINCT and wrap with COUNT aggreagate function to count the total number of days each customer has visited the restuarant.
- If we do not use DISTINCT for order_date, the number of days may be repeated. For example, if customer A visited the restaurant twice on ‘2021–01–07’, then number of days may have counted as 2 instead of 1 day.
- And lastly, use GROUP BY clause to group the result set by customer_id column.

### Output 
| customer_id | total_days_visited |
| ----------- | ------------------ |
| A           | 4                  |
| B           | 6                  |
| C           | 2                  |

- Customer A visited 4 times.
- Customer B visited 6 times.
- Customer C visited 2 times.

#

### 3. What was the first item from the menu purchased by each customer?

````sql
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
````
### Approach
- For finding out the first item purchased by each customer, use DENSE_RANK() and PARTITION BY customer_id column and ORDER BY order_date, product_id columns
- I have choose DENSE_RANK instead of ROW_NUMBER or RANK as the order_date is not time stamped hence, we do not know which item is ordered first if 2 or more items are ordered on the same day.
- And lastly, use GROUP BY clause to group the result set by customer_id and product_name column where rank is 1 only.

### Output 
| customer_id |	product_name |
| ----------- | ------------ |
| A |	sushi |
| B |	curry |
| C |	ramen |

- Customer A’s first order are curry and sushi.
- Customer B’s first order is curry.
- Customer C’s first order is ramen.

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

### Approach
- Use JOIN clause to join sales and menu table.
- Use COUNT aggregate function to count the total number of products, combined with GROUP BY and ORDER BY clause.

### Output 
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

### Approach 
- Join all the three tables since the common key was customer_id on both members and sales table.
- Filter order_date to be on or after their join_date.

### Output 
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
### Approach 
-

### Output 
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

### Output 
| customer_id |	total_distinct_items | total_amount |
| ----------- | -------------------- | ------------ |
| A | 2 | 25 |
| B | 3 | 40 |

- Before becoming members, Customer A spent $25 on 2 items.
- Before becoming members, Customer B spent $40 on 2 items.

#

### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

````sql
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
````

### Output 
| customer_id |	total_points |
| ----------- | ------------ |
| A | 860 |
| B | 940 |
| C | 360 |

- Total points of Customer A is 860.
- Total points of Customer B is 940.
- Total points of Customer C is 360.

#

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

## BONUS QUESTIONS

### 1. Recreate the table output using the available data with : customer_id, order_date, product_name, price, member (Y/N)

````sql
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
````
### Output 

| customer_id |	order_date | product_name | price | member |
| ----------- | ---------- | ------------ | ----- | ------ |
| A | 2021-01-01 | curry | 15 |	N |
| A | 2021-01-01 | sushi | 10 | N |
| A | 2021-01-07 | curry | 15 |	Y |
| A | 2021-01-10 | ramen | 12 | Y |  
| A | 2021-01-11 | ramen | 12 |	Y |
| A | 2021-01-11 | ramen | 12 |	Y |
| B | 2021-01-01 | curry | 15 | N |
| B | 2021-01-02 | curry | 15 |	N |
| B | 2021-01-04 | sushi | 10 |	N |
| B | 2021-01-11 | sushi | 10 |	Y |
| B | 2021-01-16 | ramen | 12 | Y | 
| B | 2021-02-01 | ramen | 12 |	Y |
| C | 2021-01-01 | ramen | 12 |	N |
| C | 2021-01-01 | ramen | 12 |	N |
| C | 2021-01-07 | ramen | 12 |	N |

#

### 2. Danny also requires further information about the ranking of customer products but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

````sql
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
````
### Output

| customer_id |	order_date | product_name | price | member | ranking |
| ----------- | ---------- | ------------ | ----- | ------ | ------- |
| A | 2021-01-01 | curry | 15 | N | null |
| A | 2021-01-01 | sushi | 10 |	N | null |
| A | 2021-01-07 | curry | 15 |	Y | 1 |
| A | 2021-01-10 | ramen | 12 |	Y | 2 |
| A | 2021-01-11 | ramen | 12 |	Y | 3 | 
| A | 2021-01-11 | ramen | 12 | Y | 3 |
| B | 2021-01-01 | curry | 15 | N | null |
| B | 2021-01-02 | curry | 15 |	N | null |
| B | 2021-01-04 | sushi | 10 |	N | null |
| B | 2021-01-11 | sushi | 10 | Y | 1 |
| B | 2021-01-16 | ramen | 12 |	Y | 2 |
| B | 2021-02-01 | ramen | 12 | Y | 3 |
| C | 2021-01-01 | ramen | 12 |	N | null |
| C | 2021-01-01 | ramen | 12 |	N | null |
| C | 2021-01-07 | ramen | 12 |	N | null |
