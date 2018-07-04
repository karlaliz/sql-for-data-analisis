# Modify Derek's query from the previous video in the SQL Explorer below to perform this analysis. You'll need to use occurred_at and total_amt_usd in the orders table along with LEAD to do so. In your query results, there should be four columns: occurred_at, total_amt_usd, lead, and lead_difference.

SELECT occurred_at,
		total_usd,
      	LEAD(total_usd) OVER (ORDER BY occurred_at) AS lead,
      	LEAD(total_usd) OVER (ORDER BY occurred_at) -total_usd AS lead_difference

FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_usd
  FROM orders 
 GROUP BY 1
 ) sub