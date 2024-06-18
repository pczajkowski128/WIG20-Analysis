create TABLE WIG20_Aggregates (
    Data_Date DATE PRIMARY KEY,
    Avg_Open_Price DECIMAL(10, 2),
    Avg_Highest_Price DECIMAL(10, 2),
    Avg_Lowest_Price DECIMAL(10, 2),
    Avg_Close_Price DECIMAL(10, 2),
    Avg_Adj_Close_Price DECIMAL(10, 2),
    Avg_Volume BIGINT);



INSERT INTO WIG20_Aggregates (Data_Date, Avg_Open_Price, Avg_Highest_Price, Avg_Lowest_Price, Avg_Close_Price, Avg_Adj_Close_Price, Avg_Volume)
SELECT
    Data_Date,
    AVG(Open_Price) AS Avg_Open_Price,
    AVG(Highest_Price) AS Avg_Highest_Price,
    AVG(Lowest_Price) AS Avg_Lowest_Price,
    AVG(Close_Price) AS Avg_Close_Price,
    AVG(Adj_Close_Price) AS Avg_Adj_Close_Price,
    AVG(Volume) AS Avg_Volume
FROM
    companies_quotes
GROUP BY
    Data_Date;







