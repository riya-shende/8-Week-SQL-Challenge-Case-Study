# Case Study #1 - Danny's Diner 🍜

![Case Studey 1 - Danny's Dinner](https://8weeksqlchallenge.com/images/case-study-designs/1.png)

## PROBLEM STATEMENT
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.
He plans on using these insights to help him decide whether he should expand the existing customer loyalty program.

## DATA SET
Danny has shared with you 3 key datasets for this case study :
- sales
- menu
- members

**Table 1: sales**

The sales table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.

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

The menu table maps the product_id to the actual product_name and price of each menu item.

| product_id | product_name |	price |
| ---------- | ------------ | ----- |
| 1 |	sushi |	10 |
| 2 |	curry |	15 |
| 3 |	ramen |	12 |

**Table 3: members**

The final members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.

| customer_id |	join_date |
| ----------- | --------- |
| A |	2021-01-07 |
| B	| 2021-01-09 |

## ENTITY RELATIONSHIP DIAGRAM

![Entity Relationahip Diagram](https://user-images.githubusercontent.com/121208667/209608192-331ea355-0f90-4872-9606-f22912313cb4.png)

