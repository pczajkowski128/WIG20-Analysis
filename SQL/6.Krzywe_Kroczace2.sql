-- Dodaj� nowe wpisy do tabeli krzywe_kroczace2, kt�re zawieraj� daty i nazwy sp�ek z tabeli companies_quotes
-- Filtruj� daty, aby obejmowa�y tylko te od 1 stycznia 2019 roku, dzi�ki temu iterowanie nie trwa kilku godzin, a kilkana�cie minut
-- Zapobiegam dodaniu duplikat�w poprzez sprawdzenie, czy dane ju� istniej� w tabeli krzywe_kroczace2

INSERT INTO krzywe_kroczace2 (Data, Nazwa)
SELECT DISTINCT Data_Date, Name
FROM companies_quotes
WHERE Data_Date >= '2019-01-01'
    AND NOT EXISTS (
        SELECT 1 
        FROM krzywe_kroczace2 k
        WHERE k.Data = companies_quotes.Data_Date 
            AND k.Nazwa = companies_quotes.Name);



-- Nast�pnym krokiem jest obliczenie pierwszej krzywej krocz�cej, czyli SMA
-- Dzi�ki poleceniu UPDATE + SET aktualizuj� warto�ci NULL we wcze�niej zdefiniowanej tabeli krzywe_kroczace2
-- Obliczam �redni� ruchom� (SMA) z 20 dni dla ka�dej sp�ki na podstawie cen zamkni�cia (Close_Price)
-- Warunek WHERE definiuje, kt�re rekordy w tabeli krzywe_kroczace2 maj� zosta� zaktualizowane na podstawie daty i nazwy sp�ki

UPDATE krzywe_kroczace2
SET SMA = subquery.SMA
FROM (
    SELECT
        Data_Date,
        Name,
        AVG(Close_Price) OVER (PARTITION BY Name ORDER BY Data_Date ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) AS SMA
    FROM companies_quotes
    WHERE Data_Date >= '2019-01-01'
) AS subquery
WHERE krzywe_kroczace2.Data = subquery.Data_Date AND krzywe_kroczace2.Nazwa = subquery.Name;



-- Kolejnym krokiem jest obliczenie nast�pnej krzywej krocz�cej, czyli EMA
-- Deklarujemy zmienne niezb�dne do oblicze� EMA oraz alokujemy kursor
-- Alpha to wsp�czynnik wyg�adzenia dla 12-dniowej EMA
-- Sprawdzamy, czy kursor jest ju� otwarty i je�li jest to go zamykamy
-- Inicjalizujemy nowy kursor, kt�ry iteruje przez zamkni�cia cenowe po 2019-01-01
-- Pobieramy pierwszy rekord z kursora
-- Ustalamy pocz�tkow� warto�� EMA jako pierwsz� cen� zamkni�cia po 2019-01-01
-- W p�tli, aktualizujemy warto�� EMA dla ka�dego rekordu
-- Nowa warto�� EMA jest zapisywana w tabeli krzywe_kroczace2
-- Po przetworzeniu wszystkich rekord�w zamykamy kursor i zwalniamy zasoby

DECLARE @Data DATE;
DECLARE @Nazwa VARCHAR(50);
DECLARE @Close_Price DECIMAL(18, 2);
DECLARE @Prev_EMA DECIMAL(18, 2);
DECLARE @Alpha DECIMAL(18, 4) = 2.0 / (12 + 1);  -- Alpha dla 12-dniowej EMA

-- Sprawdzenie i zamkni�cie istniej�cego kursora, je�li jest otwarty
IF CURSOR_STATUS('global', 'ema_cursor_2019') <> -3
BEGIN
    CLOSE ema_cursor_2019;
    DEALLOCATE ema_cursor_2019;
END

-- Deklaracja nowego kursora do iteracji przez zamkni�cia cenowe po 2019-01-01
DECLARE ema_cursor_2019 CURSOR FOR
    SELECT Data_Date, Name, Close_Price
    FROM companies_quotes
    WHERE Data_Date >= '2019-01-01'
    ORDER BY Name, Data_Date;

OPEN ema_cursor_2019;

-- Pobranie pierwszego rekordu
FETCH NEXT FROM ema_cursor_2019 INTO @Data, @Nazwa, @Close_Price;

-- Inicjalizacja poprzedniej warto�ci EMA pierwsz� cen� zamkni�cia po 2019-01-01
SELECT @Prev_EMA = Close_Price
FROM companies_quotes
WHERE Data_Date = (SELECT MIN(Data_Date) FROM companies_quotes WHERE Name = @Nazwa AND Data_Date >= '2019-01-01')
      AND Name = @Nazwa;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Aktualizacja warto�ci EMA, przy pierwszym przebiegu r�wna jest cenie zamkni�cia
    SET @Prev_EMA = (@Close_Price * @Alpha) + (@Prev_EMA * (1 - @Alpha));

    -- Aktualizacja warto�ci EMA w tabeli krzywe_kroczace2
    UPDATE krzywe_kroczace2
    SET EMA = @Prev_EMA
    WHERE Data = @Data AND Nazwa = @Nazwa;

    -- Pobranie kolejnego rekordu
    FETCH NEXT FROM ema_cursor_2019 INTO @Data, @Nazwa, @Close_Price;
END;

-- Zamkni�cie kursora i zwolnienie zasob�w
CLOSE ema_cursor_2019;
DEALLOCATE ema_cursor_2019;



-- Nast�pnym krokiem jest obliczenie krzywej RSI (Relative Strength Index)
-- Sprawdzenie i zamkni�cie istniej�cego kursora, je�li jest otwarty
-- Usuwanie tymczasowej tabeli #TempRSI, je�li istnieje
-- Tworzenie nowej tymczasowej tabeli #TempRSI do przechowywania danych
-- Deklaracja zmiennych niezb�dnych do oblicze� RSI
-- Kursor do iteracji przez rekordy od 2019-01-01, sortowanie wed�ug nazwy i daty
-- Otwarcie kursora i pobranie pierwszego rekordu
-- Iteracja w p�tli przez wszystkie rekordy, obliczaj�c zyski i straty
-- Warto�ci s� wstawiane do tymczasowej tabeli #TempRSI
-- Zamkni�cie i dealokacja kursora po zako�czeniu p�tli
-- U�ycie CTE (Common Table Expressions) do obliczania �rednich zysk�w i strat
-- CTE Gains oblicza �rednie zyski z 12-dniowego okresu
-- CTE Losses oblicza �rednie straty z 12-dniowego okresu
-- CTE RSI_Calc oblicza wska�nik RSI na podstawie �rednich zysk�w i strat
-- Aktualizacja tabeli krzywe_kroczace2 warto�ciami RSI z CTE RSI_Calc
-- Usuni�cie tymczasowej tabeli #TempRSI po zako�czeniu oblicze�

IF CURSOR_STATUS('global', 'rsi_cursor2019') <> -3
BEGIN
    CLOSE rsi_cursor2019;
    DEALLOCATE rsi_cursor2019;
END

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

-- Kursor do iteracji przez rekordy od 2019-01-01
DECLARE rsi_cursor2019 CURSOR FOR
    SELECT Data_Date, Name, Close_Price
    FROM companies_quotes
    WHERE Data_Date >= '2019-01-01'
    ORDER BY Name, Data_Date;

OPEN rsi_cursor2019;
FETCH NEXT FROM rsi_cursor2019 INTO @Data, @Nazwa, @Close_Price;

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

    FETCH NEXT FROM rsi_cursor2019 INTO @Data, @Nazwa, @Close_Price;
END;

CLOSE rsi_cursor2019;
DEALLOCATE rsi_cursor2019;

-- CTE do obliczania �rednich zysk�w i strat
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

-- Aktualizacja tabeli krzywe_kroczace2
UPDATE k
SET k.RSI = COALESCE(r.RSI, 0) -- Aby unikn�� NULL, przypisujemy 0
FROM krzywe_kroczace2 k
INNER JOIN RSI_Calc r ON k.Nazwa = r.Nazwa AND k.Data = r.Data;

-- Usuwanie tymczasowej tabeli
DROP TABLE #TempRSI;



-- Dodaj� nowe kolumny EMA12 i EMA26 do tabeli krzywe_kroczace2
-- Deklaruj� zmienne niezb�dne do oblicze� EMA
-- Alpha to wsp�czynnik wyg�adzenia dla 12-dniowej i 26-dniowej EMA
-- Sprawdzam, czy istniej�cy kursor jest otwarty i zamykam go, je�li tak
-- Deklaruj� nowy kursor do iteracji przez zamkni�cia cenowe po 2019-01-01
-- Otwieram kursor i pobieram pierwszy rekord
-- Inicjalizuj� poprzednie warto�ci EMA12 i EMA26 pierwsz� cen� zamkni�cia po 2019-01-01
-- W p�tli, aktualizuj� warto�ci EMA12 i EMA26 dla ka�dego rekordu
-- Nowe warto�ci EMA12 i EMA26 zapisuj� w tabeli krzywe_kroczace2
-- Pobieram kolejny rekord
-- Zamykam kursor i zwalniam zasoby
-- Obliczam warto�ci MACD jako r�nic� mi�dzy EMA12 a EMA26
-- Aktualizuj� tabel� krzywe_kroczace2 warto�ciami MACD dla rekord�w po 2019-01-01

ALTER TABLE krzywe_kroczace2
ADD EMA12 DECIMAL(18, 2),
    EMA26 DECIMAL(18, 2);


DECLARE @Data DATE;
DECLARE @Nazwa VARCHAR(50);
DECLARE @Close_Price DECIMAL(18, 2);
DECLARE @Prev_EMA12 DECIMAL(18, 2);
DECLARE @Prev_EMA26 DECIMAL(18, 2);
DECLARE @Alpha12 DECIMAL(18, 4) = 2.0 / (12 + 1);  -- Alpha dla 12-dniowej EMA
DECLARE @Alpha26 DECIMAL(18, 4) = 2.0 / (26 + 1);  -- Alpha dla 26-dniowej EMA

-- Sprawdzenie i zamkni�cie istniej�cego kursora, je�li jest otwarty
IF CURSOR_STATUS('global', 'ema_cursor_2019') <> -3
BEGIN
    CLOSE ema_cursor_2019;
    DEALLOCATE ema_cursor_2019;
END

-- Deklaracja nowego kursora do iteracji przez zamkni�cia cenowe po 2020-01-01
DECLARE ema_cursor_2019 CURSOR FOR
    SELECT Data_Date, Name, Close_Price
    FROM companies_quotes
    WHERE Data_Date >= '2019-01-01'
    ORDER BY Name, Data_Date;

OPEN ema_cursor_2020;

-- Pobranie pierwszego rekordu
FETCH NEXT FROM ema_cursor_2019 INTO @Data, @Nazwa, @Close_Price;

-- Inicjalizacja poprzednich warto�ci EMA12 i EMA26 pierwsz� cen� zamkni�cia po 2020-01-01
SELECT @Prev_EMA12 = Close_Price, @Prev_EMA26 = Close_Price
FROM companies_quotes
WHERE Data_Date = (SELECT MIN(Data_Date) FROM companies_quotes WHERE Name = @Nazwa AND Data_Date >= '2019-01-01')
      AND Name = @Nazwa;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Aktualizacja warto�ci EMA12 i EMA26
    SET @Prev_EMA12 = (@Close_Price * @Alpha12) + (@Prev_EMA12 * (1 - @Alpha12));
    SET @Prev_EMA26 = (@Close_Price * @Alpha26) + (@Prev_EMA26 * (1 - @Alpha26));

    -- Aktualizacja warto�ci EMA12 i EMA26 w tabeli krzywe_kroczace2
    UPDATE krzywe_kroczace2
    SET EMA12 = @Prev_EMA12, EMA26 = @Prev_EMA26
    WHERE Data = @Data AND Nazwa = @Nazwa;

    -- Pobranie kolejnego rekordu
    FETCH NEXT FROM ema_cursor_2020 INTO @Data, @Nazwa, @Close_Price;
END;

-- Zamkni�cie kursora i zwolnienie zasob�w
CLOSE ema_cursor_2019;
DEALLOCATE ema_cursor_2019;



-- Obliczam warto�ci MACD jako r�nic� mi�dzy EMA12 a EMA26
-- Aktualizuj� tabel� krzywe_kroczace2 warto�ciami MACD dla rekord�w po 2019-01-01
-- Poprzednie wyliczenia krzywych EMA12 i EMA26 by�y niezb�dne do obliczenia kolejnej bardzo przydatnej krzywej krocz�cej MACD

UPDATE krzywe_kroczace2
SET MACD = EMA12 - EMA26
WHERE Data >= '2019-01-01';



-- Ten skrypt oblicza warto�ci krzywej krocz�cej Signal na podstawie MACD (Moving Average Convergence Divergence).
-- Krzywa Signal jest 9-dniow� wyk�adnicz� �redni� krocz�c� warto�ci MACD.
-- Algorytm dzia�a poprzez iteracj� przez rekordy w tabeli krzywe_kroczace2, obliczaj�c Signal dla ka�dego rekordu.
-- Ustalam alpha dla Signal jako EMA(9) z MACD, co pozwala na wyg�adzanie warto�ci MACD.
-- Deklaruj� zmienne niezb�dne do przechowywania danych z kursora, w tym dat�, nazw� sp�ki oraz warto�ci MACD i Signal.
-- Deklaruj� kursor, kt�ry iteruje przez rekordy MACD w tabeli krzywe_kroczace2, sortuj�c je wed�ug nazwy sp�ki i daty.
-- W p�tli, dla ka�dego rekordu, je�li to pierwszy rekord dla danej sp�ki, inicjalizuj� warto�� Signal warto�ci� MACD.
-- Nast�pnie obliczam now� warto�� Signal jako wyg�adzenie mi�dzy bie��cym MACD a poprzedni� warto�ci� Signal.
-- Zaktualizowan� warto�� Signal zapisuj� w tabeli krzywe_kroczace2.
-- Po zako�czeniu iteracji zamykam i dealokuj� kursor, aby zwolni� zasoby.

-- Ustalenie alpha dla Signal jako EMA(9) z MACD
DECLARE @AlphaSignal DECIMAL(18, 4) = 2.0 / (9 + 1);

-- Deklaracja zmiennych kursora
DECLARE @Data DATE;
DECLARE @Nazwa VARCHAR(50);
DECLARE @MACD DECIMAL(18, 2);
DECLARE @PrevSignal DECIMAL(18, 2) = NULL; -- Startowy Signal jako NULL, aby znale�� pierwsze MACD

-- Deklaracja kursora do iteracji przez warto�ci MACD
DECLARE signal_cursor CURSOR FOR
    SELECT Data, Nazwa, MACD
    FROM krzywe_kroczace2
    WHERE Data >= '2019-01-01'
    ORDER BY Nazwa, Data;

-- Otwarcie kursora
OPEN signal_cursor;

-- Pobieranie danych
FETCH NEXT FROM signal_cursor INTO @Data, @Nazwa, @MACD;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Inicjalizacja pierwszego Signal warto�ci� pierwszego MACD
    IF @PrevSignal IS NULL
        SET @PrevSignal = @MACD;  -- Je�li to pierwszy rekord dla danej sp�ki

    -- Obliczanie Signal na podstawie aktualnego MACD i poprzedniego Signal
    SET @PrevSignal = (@MACD * @AlphaSignal) + (@PrevSignal * (1 - @AlphaSignal));

    -- Aktualizacja warto�ci Signal w tabeli
    UPDATE krzywe_kroczace2
    SET Singal = @PrevSignal
    WHERE Data = @Data AND Nazwa = @Nazwa;

    -- Pobieranie kolejnego rekordu
    FETCH NEXT FROM signal_cursor INTO @Data, @Nazwa, @MACD;
END;

-- Zamkni�cie i dealokacja zasob�w kursora
CLOSE signal_cursor;
DEALLOCATE signal_cursor;