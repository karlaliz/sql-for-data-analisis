#We want to find the average number of events for each day for each channel. The first table will provide us the number of events for each day and channel, and then we will need to average these values together using a second query.

SELECT channel, AVG(events_for_day) AS avg_event_for_day
FROM
	(SELECT DATE_TRUNC ('day',occurred_at) AS day, channel,COUNT(*) AS events_for_day
	FROM web_events
	GROUP BY 1,2) sub
GROUP BY 1
ORDER BY 2 DESC

# Same problem using WITH

WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day, 
                        channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;