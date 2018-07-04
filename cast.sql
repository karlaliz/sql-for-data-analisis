

# reorder date Notice, this new date can be operated on using DATE_TRUNC and DATE_PART in the same way as earlier lessons.

SELECT date,
(SUBSTRING (date, 7,4) ||'-'|| SUBSTRING(date, 1, 2) ||'-'||  SUBSTRING(date, 4, 2)) ::DATE  AS date_new_format
FROM sf_crime_data
LIMIT 10;