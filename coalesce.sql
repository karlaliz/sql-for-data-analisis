# 1. Notice the row with missing data.

SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

#2. Use coalesce to fill the account.id column with the account.id for the NULL value for table 1 

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
# se sustituye el valor nullo y se pide en orden cada uno de los elementos de cuenta para no repetir el id
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

#3. Fill o.account_id 

SELECT COALESCE(a.id, a.id) AS filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) AS account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

#4 Fill qty and usd columns with 0 

SELECT COALESCE(a.id, a.id) AS filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, 
COALESCE(o.account_id, a.id) AS account_id, o.occurred_at, 
COALESCE(o.standard_qty, '0') AS standard_qty, 
COALESCE(o.gloss_qty, '0') AS gloss_qty,
COALESCE(o.poster_qty,'0') AS poster_qty, 
COALESCE(o.total,0) AS total, 
COALESCE(o.standard_amt_usd, '0') AS standard_amt_usd,
COALESCE(o.gloss_amt_usd, '0') AS gloss_amt_usd,
COALESCE(o.poster_amt_usd, '0') AS poster_amt_usd,
COALESCE(o.total_amt_usd, '0') AS total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

#5 Count id

WITH t1 AS	(SELECT COALESCE(a.id, a.id) AS id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, 
	COALESCE(o.account_id, a.id) AS account_id, o.occurred_at, 
	COALESCE(o.standard_qty, '0') AS standard_qty, 
	COALESCE(o.gloss_qty, '0') AS gloss_qty,
	COALESCE(o.poster_qty,'0') AS poster_qty, 
	COALESCE(o.total,0) AS total, 
	COALESCE(o.standard_amt_usd, '0') AS standard_amt_usd,
	COALESCE(o.gloss_amt_usd, '0') AS gloss_amt_usd,
	COALESCE(o.poster_amt_usd, '0') AS poster_amt_usd,
	COALESCE(o.total_amt_usd, '0') AS total_amt_usd
	FROM accounts a
	LEFT JOIN orders o
	ON a.id = o.account_id)
SELECT COUNT(id) AS count_id
FROM t1

#6 run function without where clause

SELECT COALESCE(a.id, a.id) AS filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, 
COALESCE(o.account_id, a.id) AS account_id, o.occurred_at, 
COALESCE(o.standard_qty, '0') AS standard_qty, 
COALESCE(o.gloss_qty, '0') AS gloss_qty,
COALESCE(o.poster_qty,'0') AS poster_qty, 
COALESCE(o.total,0) AS total, 
COALESCE(o.standard_amt_usd, '0') AS standard_amt_usd,
COALESCE(o.gloss_amt_usd, '0') AS gloss_amt_usd,
COALESCE(o.poster_amt_usd, '0') AS poster_amt_usd,
COALESCE(o.total_amt_usd, '0') AS total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id

						