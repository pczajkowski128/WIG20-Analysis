INSERT INTO companies_quotes (Name, Data_Date, Open_Price, Highest_Price, Lowest_Price, Close_Price, Adj_Close_Price, Volume)
SELECT 
    'ALIOR' AS Name,
    CAST([Date] AS DATE) AS Data_Date,
    CAST([Open] AS decimal(10, 4)) AS Open_Price,
    CAST([High] AS decimal(10, 4)) AS Highest_Price,
    CAST([Low] AS decimal(10, 4)) AS Lowest_Price,
    CAST([Close] AS decimal(10, 4)) AS Close_Price,
    CAST([Adj Close] AS decimal(10, 4)) AS Adj_Close_Price,
    CAST(Volume AS bigint) AS Volume
FROM 
    ALIOR_BANK
WHERE 
    [Date] IS NOT NULL;
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;WITH LaggedPrices AS (
    SELECT
        Name,
        Data_Date,
        Close_Price,
        LAG(Close_Price) OVER (PARTITION BY Name ORDER BY Data_Date) AS Lagged_Close_Price
    FROM
        companies_quotes
)
UPDATE companies_quotes
SET Daily_Percentages = 
    CASE
        WHEN LaggedPrices.Lagged_Close_Price IS NOT NULL AND LaggedPrices.Lagged_Close_Price <> 0
            THEN ((companies_quotes.Close_Price - LaggedPrices.Lagged_Close_Price) / LaggedPrices.Lagged_Close_Price) * 100
        ELSE 0  -- Jeœli brakuje danych z poprzedniego dnia lub cena poprzedniego dnia wynosi 0, ustaw wartoœæ na 0
    END
FROM companies_quotes
JOIN LaggedPrices ON companies_quotes.Name = LaggedPrices.Name AND companies_quotes.Data_Date = LaggedPrices.Data_Date;
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2
UPDATE companies_quotes
SET Trend = CASE
    WHEN Change_Close_Price > 0 THEN 'Growing'
    WHEN Change_Close_Price < 0 THEN 'Declining'
    ELSE 'Unchanged'
END
FROM (
    -- Podzapytanie obliczaj¹ce ró¿nicê w `Close_Price` pomiêdzy rekordami dla ka¿dej firmy
    SELECT *,
        LAG(Close_Price) OVER (PARTITION BY Name ORDER BY Data_Date) AS Previous_Close_Price,
        Close_Price - LAG(Close_Price) OVER (PARTITION BY Name ORDER BY Data_Date) AS Change_Close_Price
    FROM companies_quotes
) AS Changes
WHERE companies_quotes.Name = Changes.Name
  AND companies_quotes.Data_Date = Changes.Data_Date;

-- Wyœwietl zawartoœæ tabeli `companies_quotes` po aktualizacji
SELECT *
FROM companies_quotes;
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
