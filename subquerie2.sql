
#OPTION 1
# Use DATE TRUNC to pull month level infromation about the first order ever placed in the orders table
SELECT DATE_TRUNC('month',MIN( occurred_at)) AS min_month
FROM orders

#OPTION 2
SELECT DATE_TRUNC('month', occurred_at) AS min_month
FROM orders
ORDER BY occurred_at ASC
LIMIT 1;

# Use the result of the previous query to find only the orders that to0k place in the same month and years as the first order, and then pull the avarege foe each type of paper qty in this month

SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

#1.Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT sub3.sales_rep_name, sub2.region_name, sub2.max_sales
FROM(SELECT region_name, MAX(total_amt) AS max_sales 
	FROM(SELECT SUM(o.total_amt_usd) AS total_amt , r.name AS region_name, s.name AS sales_rep_name
		FROM orders o
		JOIN accounts a
		ON a.id = o.account_id
		JOIN sales_reps s
		ON s.id = a.sales_rep_id
		JOIN region r
		ON r.id =s.region_id
		GROUP BY 2,3
		ORDER BY 1 DESC)sub1
	GROUP BY 1)sub2
JOIN(SELECT SUM(o.total_amt_usd) AS total_amt , r.name AS region_name, s.name AS sales_rep_name
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s
	ON s.id = a.sales_rep_id
	JOIN region r
	ON r.id =s.region_id
	GROUP BY 2,3
	ORDER BY 1 DESC)sub3
ON sub3.region_name= sub2.region_name AND sub3.total_amt= sub2.max_sales

#2.For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed? 

SELECT r.name, COUNT(o.total) AS total_orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id =s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) =(
	SELECT MAX(sum_sales)
	FROM	(SELECT SUM(o.total_amt_usd)AS sum_sales, r.name AS region_name
		FROM orders o
		JOIN accounts a
		ON a.id = o.account_id
		JOIN sales_reps s
		ON s.id = a.sales_rep_id
		JOIN region r
		ON r.id =s.region_id
		GROUP BY 2)t1)

#3. For the name of the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, how many accounts still had more in total purchases? 
SELECT count(*)
from ( 
  SELECT o.account_id,   sum(o.total)
  FROM orders o
  GROUP by o.account_id
  having sum(o.total) > ( 
    SELECT sum(o.total)
    FROM orders o
    where o.account_id = (
    select t1.id
    from (
        SELECT o.account_id id,   sum(o.standard_qty)
        FROM orders o
        GROUP by o.account_id
        order by 2 desc
        limit 1
      ) t1      
    )
  )
) sub1

SELECT COUNT(*)
FROM (
	SELECT a.name
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY 1
      HAVING SUM(o.total) > (
      	SELECT total 
                  FROM (
                  	SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                        FROM accounts a
                        JOIN orders o
                        ON o.account_id = a.id
                        GROUP BY 1
                        ORDER BY 2 DESC
                        LIMIT 1)
                         inner_tab)
            ) counter_tab;


# 3. ANOTHER TRY
SELECT COUNT(a.name)
FROM	(SELECT a.name, SUM(o.total)AS total_spend
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.name
	HAVING SUM(o.total) >
	(SELECT total_spend
	  FROM (SELECT a.name,SUM(o.standard_qty) AS standard_spend, SUM(o.total) AS total_spend
	    FROM accounts a
	    JOIN orders o
	    ON a.id = o.account_id
	    GROUP BY a.name
	    ORDER BY 2 DESC
	    LIMIT 1)
	  t1 ) 
	t2 );

#4For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.name, w.channel
HAVING a.name = (SELECT account_name
FROM (SELECT a.name AS account_name, SUM(o.total_amt_usd) AS total_spend_usd
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY (a.name)
  ORDER BY 2 DESC
  LIMIT 1)t1)

#5What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

SELECT AVG(total_spent)
FROM 	(SELECT a.name, SUM(o.total_amt_usd) AS total_spent
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.name
	ORDER BY 2 DESC
	LIMIT 10)sub1

#6 What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all orders.

SELECT AVG(total_spent)
FROM 	(SELECT a.name, AVG(o.total_amt_usd) AS total_spent
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.name
	HAVING AVG(o.total_amt_usd) >(SELECT AVG(o.total_amt_usd) AS first_avg
		FROM orders o)  ) sub2
