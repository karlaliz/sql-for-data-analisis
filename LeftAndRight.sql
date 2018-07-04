#1 In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.

SELECT RIGHT (website, 3) AS type_web, COUNT(*)
FROM accounts 
GROUP BY RIGHT(website, 3)

#2 There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number). 

SELECT LEFT(name, 1) AS initial, COUNT(*) AS n_companies
FROM accounts
GROUP BY LEFT(name, 1)
ORDER BY 2 DESC

#3Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?

WITH t1 AS(SELECT LEFT(LOWER(name), 1) AS initial
FROM accounts),
t2 AS  (SELECT CASE WHEN initial IN ('0','1','2','3','4','5','6','7','8','9')THEN 1 ELSE 0 END AS number,
  CASE WHEN initial IN ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z') THEN 1 ELSE 0 END AS letter
  FROM t1)
SELECT SUM(number) AS numbers, SUM(letter) AS letters
FROM t2

#4 Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?

WITH t1 AS(SELECT LEFT(LOWER(name), 1) AS initial
	FROM accounts),
t2 AS(SELECT 
		CASE WHEN initial IN ('a', 'e', 'i', 'o', 'u') THEN 1 ELSE 0 END AS vowel_name, 
		CASE WHEN initial IN ('a', 'e', 'i', 'o', 'u') THEN 0 ELSE 1 END AS other
	FROM t1)

SELECT SUM(vowel_name) AS vowel, SUM(other)AS other
FROM t2
