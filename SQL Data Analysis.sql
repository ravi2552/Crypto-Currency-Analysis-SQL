
-- Explore dataset

select * from members limit 5;
select * from prices limit 5;
select * from transactions limit 5;

-- Question
-- Sort all the rows in the table by first_name in alphabetical order and show the top 3 rows

select * from members 
order by first_name 
limit 3;

-- Question
-- Which records from trading.members are from the United States region?

SELECT * FROM members
WHERE region = 'United States';

-- Question
-- Select only the member_id and first_name columns for members who are not from Australia

SELECT
  member_id,
  first_name
FROM members
WHERE region != 'Australia';


-- Question
-- Which records from trading.members are from the United States region?

SELECT * FROM members
WHERE region = 'United States';

-- Question
-- Return the unique region values from the trading.members table and sort the output by reverse –alphabetical order

SELECT DISTINCT region
FROM members
ORDER BY region DESC;


-- Question
-- How many mentors are there per region? Sort the output by regions with the most mentors to the least

SELECT
  region,
  COUNT(*) AS mentor_count
FROM members
GROUP BY region
ORDER BY mentor_count DESC;


-- Question
-- How many US mentors and non US mentors are there?

SELECT
  (CASE
    WHEN members.region != 'United States' THEN 'Non US'
    ELSE members.region
  END) mentor_region,
  COUNT(*) AS mentor_count
FROM members
GROUP BY  (CASE
    WHEN members.region != 'United States' THEN 'Non US'
    ELSE members.region
  END)
ORDER BY mentor_count DESC;

-- Question
-- How many total records do we have in the prices table?

SELECT
  COUNT(*) AS total_records
FROM prices;



-- Question
-- How many records are there per ticker value?

SELECT
  ticker,
  COUNT(*) AS record_count
FROM prices
GROUP BY ticker;



-- Question
-- What is the minimum and maximum market_date values?

SELECT
  ticker,
  MIN(market_date) AS min_date,
  MAX(market_date) AS max_date
FROM prices
GROUP BY ticker;




select * from prices
limit 5;
-- Question
-- What is the monthly average of the price column for Ethereum in 2020? Sort the output in chronological order and also round the average price value to 2 decimal places

SELECT
  EXTRACT(month FROM market_date) AS month_start,
  CAST(ROUND(AVG(price), 2) AS DECIMAL(10,2)) AS average_eth_price
  FROM prices
  WHERE EXTRACT(YEAR FROM market_date) = 2020
  AND ticker = 'ETH'
  group by EXTRACT(month FROM market_date)
  order by EXTRACT(month FROM market_date);
  
  
  
-- Question
-- Are there any duplicate market_date values for any ticker value in our table?

SELECT 
    ticker, 
    COUNT(market_date) AS total_count, 
    COUNT(DISTINCT market_date) AS unique_count
FROM 
    prices
GROUP BY 
    ticker;

-- Question
-- How many days from the prices table exist where the high price of Bitcoin is over $20,000?

select count(*) 
from prices
where ticker = 'BTC' and high > 20000;

-- Question
-- How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker?

select ticker,
sum(case when price > open then 1 else 0 end) as breakout_days
from prices
where extract(year from market_date) = '2020'
group by ticker;



-- Question 
-- How many "non_breakout" days were there in 2020 where the price column is less than the open column for each ticker?

SELECT
  ticker,
  SUM(CASE WHEN price < open THEN 1 ELSE 0 END) AS non_breakout_days
FROM prices
WHERE EXTRACT(Year FROM market_date) = '2020'
GROUP BY ticker;

-- Question
-- What percentage of days in 2020 were breakout days vs non-breakout days? Round the percentages to 2 decimal places

SELECT
  ticker,
  ROUND(
    SUM(CASE WHEN price > open THEN 1 ELSE 0 END) / COUNT(*) * 100,
    2
  ) AS breakout_percentage,
  ROUND(
    SUM(CASE WHEN price < open THEN 1 ELSE 0 END) / COUNT(*) * 100,
    2
  ) AS non_breakout_percentage
FROM prices
WHERE YEAR(market_date) = 2020
GROUP BY ticker;


-- Question
-- How many buy and sell transactions are there for Bitcoin?

SELECT
  txn_type,
  COUNT(*) AS transaction_count
FROM transactions
WHERE ticker = 'BTC'
GROUP BY txn_type;

-- Question
-- Which members have sold less than 500 Bitcoin? Sort the output from the most BTC sold to least

WITH cte AS (
SELECT
  member_id,
  SUM(quantity) AS btc_sold_quantity
FROM transactions
WHERE ticker = 'BTC'
  AND txn_type = 'SELL'
GROUP BY member_id
)
SELECT * FROM cte
WHERE btc_sold_quantity < 500
ORDER BY btc_sold_quantity DESC;



-- Question
-- Which member_id has the highest buy to sell ratio by quantity?

SELECT
  member_id,
  SUM(CASE WHEN txn_type = 'BUY' THEN quantity ELSE 0 END) /
    SUM(CASE WHEN txn_type = 'SELL' THEN quantity ELSE 0 END) AS buy_to_sell_ratio
FROM transactions
GROUP BY member_id
ORDER BY buy_to_sell_ratio DESC;


-- Question
-- Which top 3 mentors have the most Bitcoin quantity as of the end of period?
SELECT
  members.first_name,
  SUM(
    CASE
      WHEN transactions.txn_type = 'BUY' THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) AS total_quantity
FROM transactions
INNER JOIN members
  ON transactions.member_id = members.member_id
WHERE ticker = 'BTC'
GROUP BY members.first_name
ORDER BY total_quantity DESC
LIMIT 3;













































