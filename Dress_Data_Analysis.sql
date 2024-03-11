SELECT *
FROM Dresses$

-- Filling NULL values appropriate value in sleeve_type column

SELECT COUNT(*)
FROM Dresses$
WHERE sleeve_type IS NULL

UPDATE Dresses$
SET sleeve_type = CASE WHEN sleeve_type IS  NULL THEN 'Full sleeve' ELSE sleeve_type END

-- Extracting brand with only having single sale

SELECT brand,rn 
FROM (SELECT *,ROW_NUMBER() OVER (PARTITION BY brand ORDER BY F1) AS rn
        FROM Dresses$) AS t1
WHERE rn=1

-- Sort data according to brand and description and find average price,average reduction percentage,no.of sales

SELECT brand,description,AVG(price),AVG(reduction_percentage),Count(*)
FROM Dresses$
GROUP BY brand,description
ORDER BY 5 DESC