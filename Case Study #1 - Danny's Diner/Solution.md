# Solution

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

````sql
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
````
### Approach 
- We create a CTE to rank the number of orders for each product by DESC order for each customer.
- Then generate results where rank of product = 1 only as the most popular product for individual customer.

### Output
| customer_id |	product_name | order_count |
| ----------- | ------------ | ----------- |
| A | ramen | 3 |
| B | sushi | 2 |
| B | curry | 2 |
| B | ramen | 2 |
| C | ramen | 3 |
		  
- Customer A and C’s favourite item is ramen.
- Customer B enjoys all items in the menu. 

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
- Use DENSE RANK by partitioning customer_id and ORDER BY DESC order_date to find out the order_date just before the customer became member
- Filter order_date before join_date.
- Then generate results where rank = 1 only as the purchased item just before the customer became a member.

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
### Approach
- First, filter order_date before their join_date
- Then, COUNT unique product_id and SUM the prices total spent before becoming member.
- Join all the three tables since the common key was customer_id on both members and sales table.
- And lastly, use GROUP BY clause to group the result set by customer_id column.

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
### Approach
- use CASE WHEN to create conditional statements.
- If product_id = 1, then every $1 price multiply by 20 points.
- All other product_id that is not 1, multiply $1 by 10 points.
- we SUM the price, match it to the product_id and SUM the total_points.

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

````sql
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
````

### Approach
- Use SUM with CASE function
- Join all the three tables
- And lastly, use GROUP BY clause to group the result set by customer_id column.

### Output
| customer_id | Points |
| ----------- | -------|
| A | 1370 |
| B | 940 | 

- Customer A has 1,370 points.
- Customer B has 940 points.


## Bonus Question

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


# Insights
From the analysis, we discover a few interesting insights that would be certainly useful for Danny.

- Customer B is the most frequent visitor with 6 visits in Jan 2021.
- Danny’s Diner’s most popular item is ramen, followed by curry and sushi.
- Customer A and C loves ramen whereas Customer B seems to enjoy sushi, curry and ramen equally. Who knows, I might be Customer B!
- Customer A is the 1st member of Danny’s Diner and his first order is curry. Gotta fulfill his curry cravings!
- The last item ordered by Customers A and B before they became members are sushi and curry. Does it mean both of these items are the deciding factor? It must be really delicious for them to sign up as members!
- Before they became members, both Customers A and B spent $25 and $40.
- Throughout Jan 2021, their points for Customer A : 860, Customer B : 940 and Customer C : 360.
- Assuming that members can earn 2x a week from the day they became a member with bonus 2x points for sushi, Customer A has 660 points and Customer B has 340 by the end of Jan 2021.

