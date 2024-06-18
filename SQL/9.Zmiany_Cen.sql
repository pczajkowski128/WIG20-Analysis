-- W tym skrypcie tworz� tabel� CompanyPriceChanges, kt�ra b�dzie przechowywa� zmiany cen sp�ek na przestrzeni r�nych okres�w czasowych
-- Dane dotycz�ce cen sp�ek s� pobierane z tabeli companies_quotes
-- Celem jest �ledzenie zmian cen akcji na przestrzeni dnia, tygodnia, miesi�ca, sze�ciu miesi�cy, roku, dw�ch lat i czterech lat

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



-- W tym skrypcie tworz� i wykorzystuj� funkcj� do obliczania mediany oraz aktualizuj� tabel� CompanyPriceChanges, aby przechowywa�a zmiany cen sp�ek na przestrzeni r�nych okres�w czasowych
-- Dane dotycz�ce cen sp�ek s� przechowywane w tabeli companies_quotes
-- Skrypt sk�ada si� z kilku krok�w:
-- 1. Tworzenie funkcji dbo.Median, kt�ra oblicza median� cen zamkni�cia sp�ki w okre�lonym okresie
-- 2. Wstawienie unikalnych nazw sp�ek i dat do tabeli CompanyPriceChanges
-- 3. Obliczenie ostatnich cen zamkni�cia dla ka�dej sp�ki
-- 4. Obliczenie zmian cen w r�nych okresach czasowych (dzie�, tydzie�, miesi�c, sze�� miesi�cy, rok, dwa lata, cztery lata)
-- 5. Aktualizacja tabeli CompanyPriceChanges warto�ciami tych zmian

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


-- Wstawienie unikalnych nazw sp�ek i dat do tabeli CompanyPriceChanges
INSERT INTO CompanyPriceChanges (Name, Data_Date)
SELECT DISTINCT Name, Data_Date
FROM companies_quotes
WHERE Name IN ('MBANK', 'PGE', 'JSW', 'PZU', 'CD_PROJECT', 'PKOBP', 'SANPL', 'LPP', 'ALLEGRO', 'ORANGEPL', 'CYFRPLSAT', 'KETY', 'KRUK', 'PKNORLEN', 'KGHM', 'BUDIMEX', 'PEKAO', 'ALIOR', 'PEPCO', 'DINO');
GO


-- Pobranie ostatnich cen zamkni�cia dla ka�dej sp�ki
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


