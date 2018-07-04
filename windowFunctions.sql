# example understanding Window functions
SELECT  account_id, SUM(standard_amt_usd) OVER (ORDER BY account_id) AS new_group
FROM orders

SELECT account_id, SUM(standard_amt_usd)
FROM orders
GROUP BY account_id
ORDER BY 1

#Create another running total. This time, create a running total of standard_amt_usd (in the orders table) over order time with no date truncation. Your final table should have two columns: one with the amount being added for each new row, and a second with the running total.

SELECT  standard_amt_usd, SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders

#Now, modify your query from the previous quiz to include partitions. Still create a running total of standard_amt_usd (in the orders table) over order time, but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable. Your final table should have three columns: One with the amount being added for each row, one for the truncated date, and a final columns with the running total within each year.

SELECT  standard_amt_usd, 
DATE_TRUNC('year', occurred_at) AS year, 
SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at)  ORDER BY occurred_at) AS running_total
FROM orders

# Example from 

The concept is very well explained by the accepted answer, but I find that the more example one sees, the better it sinks in. Here's an incremental example:

1) Boss says "get me number of items we have in stock grouped by brand"

You say: "no problem"

SELECT 
      BRAND
      ,COUNT(ITEM_ID) 
FROM 
      ITEMS
GROUP BY 
      BRAND;
Result:

+--------------+---------------+
|  Brand       |   Count       | 
+--------------+---------------+
| H&M          |     50        |
+--------------+---------------+
| Hugo Boss    |     100       |
+--------------+---------------+
| No brand     |     22        |
+--------------+---------------+
2) The boss says "Now get me a list of all items, with their brand AND number of items that have that brand"

You may try:

 SELECT 
      ITEM_NR
      ,BRAND
      ,COUNT(ITEM_ID) 
 FROM 
      ITEMS
 GROUP BY 
      BRAND;
But you get:

ORA-00979: not a GROUP BY expression 
This is where the OVER (PARTITION BY BRAND) comes in:

 SELECT 
      ITEM_NR
      ,BRAND
      ,COUNT(ITEM_ID) OVER (PARTITION BY BRAND) 
 FROM 
      ITEMS;
Whic means:

COUNT(ITEM_ID) - get the number of items
OVER - Over the set of rows
(PARTITION BY BRAND) - that have the same brand
And the result is:

+--------------+---------------+----------+
|  Items       |  Brand        | Count()  |
+--------------+---------------+----------+
|  Item 1      |  Hugo Boss    |   100    | 
+--------------+---------------+----------+
|  Item 2      |  Hugo Boss    |   100    | 
+--------------+---------------+----------+
|  Item 3      |  No brand     |   22     | 
+--------------+---------------+----------+
|  Item 4      |  No brand     |   22     | 
+--------------+---------------+----------+
|  Item 5      |  H&M          |   50     | 
+--------------+---------------+----------+