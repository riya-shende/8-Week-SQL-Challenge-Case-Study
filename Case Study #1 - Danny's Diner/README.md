# Case Study #1 - Danny's Diner 🍜

![Case Studey 1 - Danny's Dinner](https://8weeksqlchallenge.com/images/case-study-designs/1.png)

# Table of Contents
1. [Problem Statement](#problem-statement)
2. [Data Set](#data-set)
3. [Entity Relationship Diagram](#entity-relationship-diagram)
4. [Case Study Questions](#case-study-questions)
5. [Solution and Insights](https://github.com/riya-shende/8-Week-SQL-Challenge-Case-Study/blob/main/Case%20Study%20%231%20-%20Danny's%20Diner/Solution.md)

# Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.
He plans on using these insights to help him decide whether he should expand the existing customer loyalty program.

# Data Set
There are 3 tables for this case study :
- sales : The sales table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.
- menu : The menu table maps the product_id to the actual product_name and price of each menu item.
- members : The final members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.


**Table 1: sales**

| customer_id | order_date | product_id |
| ----------- | ---------- | ---------- |
| A |	2021-01-01 | 1 |
| A	| 2021-01-01 | 2 | 
| A |	2021-01-07 | 2 |
| A |	2021-01-10 | 3 |
| A |	2021-01-11 | 3 |
| A |	2021-01-11 | 3 |
| B | 2021-01-01 | 2 |
| B |	2021-01-02 | 2 |
| B |	2021-01-04 | 1 |
| B |	2021-01-11 | 1 |
| B |	2021-01-16 | 3 |
| B | 2021-02-01 | 3 |
| C |	2021-01-01 | 3 |
| C |	2021-01-01 | 3 |
| C |	2021-01-07 | 3 |


**Table 2: menu**

| product_id | product_name |	price |
| ---------- | ------------ | ----- |
| 1 |	sushi |	10 |
| 2 |	curry |	15 |
| 3 |	ramen |	12 |


**Table 3: members**

| customer_id |	join_date |
| ----------- | --------- |
| A |	2021-01-07 |
| B	| 2021-01-09 |


# Entity Relationship Diagram

![image](https://user-images.githubusercontent.com/98699089/156034410-8775d5d2-eda5-4453-9e33-54bfef253084.png)

# Case Study Questions
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

# Solution and Insights
For solution and Insights, [click here](https://github.com/riya-shende/8-Week-SQL-Challenge-Case-Study/blob/main/Case%20Study%20%231%20-%20Danny's%20Diner/Solution.md)
