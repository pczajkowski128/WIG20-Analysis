-- W tym skrypcie tworzê tabelê CompanyPriceChanges, która bêdzie przechowywaæ zmiany cen spó³ek na przestrzeni ró¿nych okresów czasowych
-- Dane dotycz¹ce cen spó³ek s¹ pobierane z tabeli companies_quotes
-- Celem jest œledzenie zmian cen akcji na przestrzeni dnia, tygodnia, miesi¹ca, szeœciu miesiêcy, roku, dwóch lat i czterech lat

CREATE TABLE CompanyPriceChanges (
    Name VARCHAR(100),
    Data_Date DATE,
    DayChange DECIMAL(18,2),
    WeekChange DECIMAL(18,2),
    MonthChange DECIMAL(18,2),
    SixMonthsChange DECIMAL(18,2),
    YearChange DECIMAL(18,2),
    TwoYearsChange DECIMAL(18,2),
    FourYearsChange DECIMAL(18,2));



-- W tym skrypcie tworzê i wykorzystujê funkcjê do obliczania mediany oraz aktualizujê tabelê CompanyPriceChanges, aby przechowywa³a zmiany cen spó³ek na przestrzeni ró¿nych okresów czasowych
-- Dane dotycz¹ce cen spó³ek s¹ przechowywane w tabeli companies_quotes
-- Skrypt sk³ada siê z kilku kroków:
-- 1. Tworzenie funkcji dbo.Median, która oblicza medianê cen zamkniêcia spó³ki w okreœlonym okresie
-- 2. Wstawienie unikalnych nazw spó³ek i dat do tabeli CompanyPriceChanges
-- 3. Obliczenie ostatnich cen zamkniêcia dla ka¿dej spó³ki
-- 4. Obliczenie zmian cen w ró¿nych okresach czasowych (dzieñ, tydzieñ, miesi¹c, szeœæ miesiêcy, rok, dwa lata, cztery lata)
-- 5. Aktualizacja tabeli CompanyPriceChanges wartoœciami tych zmian

CREATE OR ALTER FUNCTION dbo.Median(@Name VARCHAR(100), @BaseDate DATE, @DaysBack INT) -- Tworzenie funkcji mediany
RETURNS DECIMAL(18, 4)
AS
BEGIN
    DECLARE @Median DECIMAL(18, 4);
    SELECT @Median = AVG(Close_Price) 
    FROM (
        SELECT TOP 1 WITH TIES Close_Price
        FROM companies_quotes
        WHERE Name = @Name AND Data_Date <= DATEADD(day, @DaysBack, @BaseDate)
        ORDER BY ABS(DATEDIFF(day, Data_Date, DATEADD(day, @DaysBack, @BaseDate)))
    ) AS T;
    RETURN @Median;
END;
GO


-- Wstawienie unikalnych nazw spó³ek i dat do tabeli CompanyPriceChanges
INSERT INTO CompanyPriceChanges (Name, Data_Date)
SELECT DISTINCT Name, Data_Date
FROM companies_quotes
WHERE Name IN ('MBANK', 'PGE', 'JSW', 'PZU', 'CD_PROJECT', 'PKOBP', 'SANPL', 'LPP', 'ALLEGRO', 'ORANGEPL', 'CYFRPLSAT', 'KETY', 'KRUK', 'PKNORLEN', 'KGHM', 'BUDIMEX', 'PEKAO', 'ALIOR', 'PEPCO', 'DINO');
GO


-- Pobranie ostatnich cen zamkniêcia dla ka¿dej spó³ki
WITH LatestPrices AS (
    SELECT 
        Name,
        MAX(Data_Date) AS LatestDate
    FROM companies_quotes
    GROUP BY Name
),
BasePrices AS (
    SELECT 
        lp.Name,
        lp.LatestDate,
        cq.Close_Price AS BaseClosePrice
    FROM LatestPrices lp
    JOIN companies_quotes cq ON lp.Name = cq.Name AND lp.LatestDate = cq.Data_Date
),
PriceChanges AS (
    SELECT 
        cq.Name,
        cq.Data_Date,
        cq.Close_Price,
        bp.BaseClosePrice,
        (bp.BaseClosePrice - dbo.Median(cq.Name, bp.LatestDate, -1)) AS DayChange,
        (bp.BaseClosePrice - dbo.Median(cq.Name, bp.LatestDate, -7)) AS WeekChange,
        (bp.BaseClosePrice - dbo.Median(cq.Name, bp.LatestDate, -30)) AS MonthChange,
        (bp.BaseClosePrice - dbo.Median(cq.Name, bp.LatestDate, -183)) AS SixMonthsChange,
        (bp.BaseClosePrice - dbo.Median(cq.Name, bp.LatestDate, -365)) AS YearChange,
        (bp.BaseClosePrice - dbo.Median(cq.Name, bp.LatestDate, -730)) AS TwoYearsChange,
        (bp.BaseClosePrice - dbo.Median(cq.Name, bp.LatestDate, -1460)) AS FourYearsChange
    FROM companies_quotes cq
    JOIN BasePrices bp ON cq.Name = bp.Name
)
UPDATE CompanyPriceChanges
SET
    DayChange = pc.DayChange,
    WeekChange = pc.WeekChange,
    MonthChange = pc.MonthChange,
    SixMonthsChange = pc.SixMonthsChange,
    YearChange = pc.YearChange,
    TwoYearsChange = pc.TwoYearsChange,
    FourYearsChange = pc.FourYearsChange
FROM PriceChanges pc
WHERE CompanyPriceChanges.Name = pc.Name AND CompanyPriceChanges.Data_Date = pc.Data_Date;
GO


