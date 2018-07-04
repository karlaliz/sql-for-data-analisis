# 1. Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
WITH t1 AS 	(SELECT 
	LEFT(primary_poc, (STRPOS(primary_poc, ' ')-1))AS
	first_name,
	RIGHT(primary_poc, (LENGTH(primary_poc))-(STRPOS(primary_poc, ' '))) AS last_name,
	name AS name                                             
	FROM accounts a)

SELECT CONCAT(first_name,'.', last_name, '@', name, '.com') AS email 
FROM t1 

#2 You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1. Some helpful documentation is here.

WITH t1 AS 	(SELECT 
	LEFT(primary_poc, (STRPOS(primary_poc, ' ')-1))AS
	first_name,
	RIGHT(primary_poc, (LENGTH(primary_poc))-(STRPOS(primary_poc, ' '))) AS last_name,
	REPLACE(name, ' ', '') AS name                                             
	FROM accounts a)

SELECT CONCAT(first_name,'.', last_name, '@', name, '.com') AS email 
FROM t1 

#3 We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.


WITH t1 AS 	(SELECT 
	LEFT(primary_poc, (STRPOS(primary_poc, ' ')-1))AS
	first_name,
	RIGHT(primary_poc, (LENGTH(primary_poc))-(STRPOS(primary_poc, ' '))) AS last_name,
	name AS name                                             
	FROM accounts a),
t2 AS (SELECT first_name, last_name, 
	CONCAT(first_name,'.', last_name, '@', name, '.com') AS email , 
	LEFT(first_name, 1) AS one, 
	RIGHT(first_name, 1) AS two, 
	LEFT(last_name, 1) AS three, 
	RIGHT(last_name, 1) AS four, 
	LENGTH(first_name) AS five, 
	LENGTH(last_name) AS six, 
	LOWER(REPLACE(name, ' ', '')) AS seven  
	FROM t1)

SELECT first_name, last_name, email, CONCAT(one, two, three, four, five, six, seven) AS password
FROM t2