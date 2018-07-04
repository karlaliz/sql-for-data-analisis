#1.Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales. 

WITH sales AS	(SELECT  r.name AS region_name, s.name AS sales_name, SUM(o.total_amt_usd) AS total_sales
	FROM orders o
	JOIN accounts a
	ON a.id =o.account_id
	JOIN sales_reps s
	ON s.id =a.sales_rep_id
	JOIN region r
	ON  r.id = s.region_id
	GROUP BY r.name, s.name),

sales_by_region AS(SELECT region_name, MAX(total_sales) AS max_sales
	FROM sales
	GROUP BY region_name
	ORDER BY 2 DESC)
SELECT sales_by_region.region_name,sales_by_region.max_sales, sales.sales_name
FROM sales
JOIN sales_by_region
ON sales.region_name = sales_by_region.region_name AND sales.total_sales = sales_by_region.max_sales

#2.For the region with the largest sales total_amt_usd, how many total orders were placed? 

WITH t1 AS (SELECT  r.name AS region_name, SUM(o.total_amt_usd) AS total_sales
	FROM orders o
	JOIN accounts a
	ON a.id =o.account_id
	JOIN sales_reps s
	ON s.id =a.sales_rep_id
	JOIN region r
	ON  r.id = s.region_id
	GROUP BY r.name
	ORDER BY 2 DESC
	LIMIT 1),
t2 AS	(SELECT t1.region_name
	FROM t1)
SELECT COUNT(o.total),r.name
FROM orders o
JOIN accounts a
ON a.id =o.account_id
JOIN sales_reps s
ON s.id =a.sales_rep_id
JOIN region r
ON  r.id = s.region_id
GROUP BY r.name
HAVING r.name = (SELECT * FROM t2)

#3 For the name of the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, how many accounts still had more in total purchases? 

WITH t1 AS	(SELECT a.name, SUM(o.standard_qty) AS sales_standard, SUM(o.total) AS sales_total
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.name 
	ORDER BY 2 DESC
	LIMIT 1),

t2 AS	(SELECT a.name, SUM(o.total) AS sales_total
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.name
	HAVING SUM(o.total)>(SELECT t1.sales_total FROM t1))

SELECT COUNT(*)
FROM t2

#4.For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

WITH t1 AS	(SELECT a.name AS costumer, SUM(total_amt_usd)
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.name
	ORDER BY 2 DESC
	LIMIT 1)

SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.name, w.channel
HAVING  a.name = (SELECT t1.costumer FROM t1)
ORDER BY 3 DESC

#5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?  

WITH top_ten AS (SELECT a.name AS name, SUM(o.total_amt_usd) AS total_spend
	FROM accounts a
	JOIN orders o
	ON a.id =o.account_id
	GROUP BY a.name
	ORDER BY 2 DESC
	LIMIT 10)
SELECT AVG(total_spend)
FROM top_ten

#6 What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all accounts.

WITH t1 AS	(SELECT AVG(o.total_amt_usd) AS avg_spend
	FROM orders o),
 t2 AS (SELECT a.name AS name, AVG(o.total_amt_usd) AS avg_spend
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY a.name
  HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(t2.avg_spend)
FROM t2