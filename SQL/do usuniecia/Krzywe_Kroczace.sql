create table krzywe_kroczace (
	Data Date,
	Nazwa varchar(50),
	SMA decimal(18, 2),
	EMA decimal(18, 2),
	RSI decimal(18, 2),
	MACD decimal(18, 2));

ALTER TABLE krzywe_kroczace ADD Signal DECIMAL(18, 4);

select * from krzywe_kroczace
WHERE Nazwa = 'ALIOR'
AND Data BETWEEN '2012-12-17' AND '2013-01-17';

update krzywe_kroczace
set Nazwa = 'DINO'
where Nazwa = 'DINOPL'

INSERT INTO krzywe_kroczace (Data, Nazwa, SMA)
SELECT
    Data_Date,
    Name,
    AVG(Close_Price) OVER (PARTITION BY Name ORDER BY Data_Date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) AS SMA_20
FROM
    companies_quotes;
###########################################
DECLARE @Data DATE;
DECLARE @Nazwa VARCHAR(50);
DECLARE @Close_Price DECIMAL(18, 2);
DECLARE @Prev_EMA DECIMAL(18, 2);
DECLARE @Alpha DECIMAL(18, 4) = 2.0 / (12 + 1);  -- Alpha dla 12-dniowej EMA

-- Deklaracja kursora do iteracji przez zamkniêcia cenowe
DECLARE ema_cursor CURSOR FOR
    SELECT Data_Date, Name, Close_Price
    FROM companies_quotes
    ORDER BY Name, Data_Date;

OPEN ema_cursor;

-- Pobranie pierwszego rekordu
FETCH NEXT FROM ema_cursor INTO @Data, @Nazwa, @Close_Price;

-- Inicjalizacja poprzedniej wartoœci EMA pierwsz¹ cen¹ zamkniêcia
SELECT @Prev_EMA = Close_Price
FROM companies_quotes
WHERE Data_Date = (SELECT MIN(Data_Date) FROM companies_quotes WHERE Name = @Nazwa) AND Name = @Nazwa;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Aktualizacja wartoœci EMA, przy pierwszym przebiegu równa jest cenie zamkniêcia
    SET @Prev_EMA = (@Close_Price * @Alpha) + (@Prev_EMA * (1 - @Alpha));

    -- Aktualizacja wartoœci EMA w tabeli krzywe_kroczace
    UPDATE krzywe_kroczace
    SET EMA = @Prev_EMA
    WHERE Data = @Data AND Nazwa = @Nazwa;

    -- Pobranie kolejnego rekordu
    FETCH NEXT FROM ema_cursor INTO @Data, @Nazwa, @Close_Price;
END;

-- Zamkniêcie kursora i zwolnienie zasobów
CLOSE ema_cursor;
DEALLOCATE ema_cursor;
#############################################




IF OBJECT_ID('tempdb..#TempRSI') IS NOT NULL
    DROP TABLE #TempRSI;

CREATE TABLE #TempRSI (
    Data DATE,
    Nazwa VARCHAR(50),
    Close_Price DECIMAL(18, 2),
    Gain DECIMAL(18, 2) DEFAULT 0,
    Loss DECIMAL(18, 2) DEFAULT 0
);

-- Przygotowanie danych
DECLARE @Data DATE;
DECLARE @Nazwa VARCHAR(50);
DECLARE @Close_Price DECIMAL(18, 2);
DECLARE @Prev_Close_Price DECIMAL(18, 2) = NULL;

-- Kursor do iteracji przez rekordy
DECLARE rsi_cursor CURSOR FOR
    SELECT Data_Date, Name, Close_Price
    FROM companies_quotes
    ORDER BY Name, Data_Date;

OPEN rsi_cursor;
FETCH NEXT FROM rsi_cursor INTO @Data, @Nazwa, @Close_Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @Prev_Close_Price IS NOT NULL
    BEGIN
        INSERT INTO #TempRSI (Data, Nazwa, Close_Price, Gain, Loss)
        VALUES (
            @Data, 
            @Nazwa, 
            @Close_Price, 
            CASE WHEN @Close_Price > @Prev_Close_Price THEN @Close_Price - @Prev_Close_Price ELSE 0 END,
            CASE WHEN @Close_Price < @Prev_Close_Price THEN @Prev_Close_Price - @Close_Price ELSE 0 END
        );
    END
    SET @Prev_Close_Price = @Close_Price;

    FETCH NEXT FROM rsi_cursor INTO @Data, @Nazwa, @Close_Price;
END;

CLOSE rsi_cursor;
DEALLOCATE rsi_cursor;

-- CTE do obliczania œrednich zysków i strat
WITH Gains AS (
    SELECT
        Nazwa,
        Data,
        AVG(Gain) OVER (PARTITION BY Nazwa ORDER BY Data ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS AvgGain
    FROM #TempRSI
),
Losses AS (
    SELECT
        Nazwa,
        Data,
        AVG(Loss) OVER (PARTITION BY Nazwa ORDER BY Data ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS AvgLoss
    FROM #TempRSI
),
RSI_Calc AS (
    SELECT
        g.Nazwa,
        g.Data,
        100.0 - (100.0 / (1.0 + g.AvgGain / NULLIF(l.AvgLoss, 0))) AS RSI
    FROM Gains g
    JOIN Losses l ON g.Nazwa = l.Nazwa AND g.Data = l.Data
)

-- Aktualizacja tabeli krzywe_kroczace
UPDATE k
SET k.RSI = COALESCE(r.RSI, 0) -- Aby unikn¹æ NULL, przypisujemy 0
FROM krzywe_kroczace k
INNER JOIN RSI_Calc r ON k.Nazwa = r.Nazwa AND k.Data = r.Data;

-- Usuwanie tymczasowej tabeli
DROP TABLE #TempRSI;
############




DECLARE @Data DATE;
DECLARE @Nazwa VARCHAR(50);
DECLARE @Close_Price DECIMAL(18, 2);
DECLARE @EMA12 DECIMAL(18, 2), @EMA26 DECIMAL(18, 2), @Signal DECIMAL(18, 2), @MACD DECIMAL(18, 2);
DECLARE @Alpha12 DECIMAL(18, 4) = 2.0 / (12 + 1);  -- Alpha dla 12-dniowej EMA
DECLARE @Alpha26 DECIMAL(18, 4) = 2.0 / (26 + 1);  -- Alpha dla 26-dniowej EMA
DECLARE @AlphaSignal DECIMAL(18, 4) = 2.0 / (9 + 1);  -- Alpha dla sygna³u EMA (9-dniowej EMA z MACD)

DECLARE macd_cursor CURSOR FOR
    SELECT Data_Date, Name, Close_Price
    FROM companies_quotes
    ORDER BY Name, Data_Date;

OPEN macd_cursor;
FETCH NEXT FROM macd_cursor INTO @Data, @Nazwa, @Close_Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Inicjalizacja EMA12 i EMA26 jeœli to pierwszy rekord dla danej spó³ki
    IF @Data = (SELECT MIN(Data_Date) FROM companies_quotes WHERE Name = @Nazwa)
    BEGIN
        SELECT @EMA12 = Close_Price, @EMA26 = Close_Price, @Signal = 0
        FROM companies_quotes
        WHERE Data_Date = @Data AND Name = @Nazwa;
    END

    -- Obliczanie EMA12, EMA26 i MACD
    SET @EMA12 = (@Close_Price * @Alpha12) + (@EMA12 * (1 - @Alpha12));
    SET @EMA26 = (@Close_Price * @Alpha26) + (@EMA26 * (1 - @Alpha26));
    SET @MACD = @EMA12 - @EMA26;

    -- Obliczanie Sygna³u
    SET @Signal = (@MACD * @AlphaSignal) + (@Signal * (1 - @AlphaSignal));

    -- Aktualizacja lub wstawianie wartoœci MACD i Sygna³u do tabeli
    UPDATE krzywe_kroczace
    SET MACD = @MACD, Signal = @Signal
    WHERE Data = @Data AND Nazwa = @Nazwa;

    FETCH NEXT FROM macd_cursor INTO @Data, @Nazwa, @Close_Price;
END;

CLOSE macd_cursor;
DEALLOCATE macd_cursor;


select * from krzywe_kroczace;









