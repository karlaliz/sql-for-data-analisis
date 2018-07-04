#We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

SELECT a.name, SUM(o.total_amt_usd)AS total_sales,CASE WHEN SUM(o.total_amt_usd) >200000 THEN 'first' WHEN SUM(o.total_amt_usd) > 100000 THEN 'second'  WHEN  SUM(o.total_amt_usd) < 100000 THEN 'third' END  AS level
FROM accounts a
JOIN orders o
ON a.id =o.account_id
GROUP BY a.name
ORDER BY 2 DESC;