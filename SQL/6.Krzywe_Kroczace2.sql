-- Dodajê nowe wpisy do tabeli krzywe_kroczace2, które zawieraj¹ daty i nazwy spó³ek z tabeli companies_quotes
-- Filtrujê daty, aby obejmowa³y tylko te od 1 stycznia 2019 roku, dziêki temu iterowanie nie trwa kilku godzin, a kilkanaœcie minut
-- Zapobiegam dodaniu duplikatów poprzez sprawdzenie, czy dane ju¿ istniej¹ w tabeli krzywe_kroczace2

INSERT INTO krzywe_kroczace2 (Data, Nazwa)
SELECT DISTINCT Data_Date, Name
FROM companies_quotes
WHERE Data_Date >= '2019-01-01'
    AND NOT EXISTS (
        SELECT 1 
        FROM krzywe_kroczace2 k
        WHERE k.Data = companies_quotes.Data_Date 
            AND k.Nazwa = companies_quotes.Name);



-- Nastêpnym krokiem jest obliczenie pierwszej krzywej krocz¹cej, czyli SMA
-- Dziêki poleceniu UPDATE + SET aktualizujê wartoœci NULL we wczeœniej zdefiniowanej tabeli krzywe_kroczace2
-- Obliczam œredni¹ ruchom¹ (SMA) z 20 dni dla ka¿dej spó³ki na podstawie cen zamkniêcia (Close_Price)
-- Warunek WHERE definiuje, które rekordy w tabeli krzywe_kroczace2 maj¹ zostaæ zaktualizowane na podstawie daty i nazwy spó³ki

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



-- Kolejnym krokiem jest obliczenie nastêpnej krzywej krocz¹cej, czyli EMA
-- Deklarujemy zmienne niezbêdne do obliczeñ EMA oraz alokujemy kursor
-- Alpha to wspó³czynnik wyg³adzenia dla 12-dniowej EMA
-- Sprawdzamy, czy kursor jest ju¿ otwarty i jeœli jest to go zamykamy
-- Inicjalizujemy nowy kursor, który iteruje przez zamkniêcia cenowe po 2019-01-01
-- Pobieramy pierwszy rekord z kursora
-- Ustalamy pocz¹tkow¹ wartoœæ EMA jako pierwsz¹ cenê zamkniêcia po 2019-01-01
-- W pêtli, aktualizujemy wartoœæ EMA dla ka¿dego rekordu
-- Nowa wartoœæ EMA jest zapisywana w tabeli krzywe_kroczace2
-- Po przetworzeniu wszystkich rekordów zamykamy kursor i zwalniamy zasoby

DECLARE @Data DATE;
DECLARE @Nazwa VARCHAR(50);
DECLARE @Close_Price DECIMAL(18, 2);
DECLARE @Prev_EMA DECIMAL(18, 2);
DECLARE @Alpha DECIMAL(18, 4) = 2.0 / (12 + 1);  -- Alpha dla 12-dniowej EMA

-- Sprawdzenie i zamkniêcie istniej¹cego kursora, jeœli jest otwarty
IF CURSOR_STATUS('global', 'ema_cursor_2019') <> -3
BEGIN
    CLOSE ema_cursor_2019;
    DEALLOCATE ema_cursor_2019;
END

-- Deklaracja nowego kursora do iteracji przez zamkniêcia cenowe po 2019-01-01
DECLARE ema_cursor_2019 CURSOR FOR
    SELECT Data_Date, Name, Close_Price
    FROM companies_quotes
    WHERE Data_Date >= '2019-01-01'
    ORDER BY Name, Data_Date;

OPEN ema_cursor_2019;

-- Pobranie pierwszego rekordu
FETCH NEXT FROM ema_cursor_2019 INTO @Data, @Nazwa, @Close_Price;

-- Inicjalizacja poprzedniej wartoœci EMA pierwsz¹ cen¹ zamkniêcia po 2019-01-01
SELECT @Prev_EMA = Close_Price
FROM companies_quotes
WHERE Data_Date = (SELECT MIN(Data_Date) FROM companies_quotes WHERE Name = @Nazwa AND Data_Date >= '2019-01-01')
      AND Name = @Nazwa;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Aktualizacja wartoœci EMA, przy pierwszym przebiegu równa jest cenie zamkniêcia
    SET @Prev_EMA = (@Close_Price * @Alpha) + (@Prev_EMA * (1 - @Alpha));

    -- Aktualizacja wartoœci EMA w tabeli krzywe_kroczace2
    UPDATE krzywe_kroczace2
    SET EMA = @Prev_EMA
    WHERE Data = @Data AND Nazwa = @Nazwa;

    -- Pobranie kolejnego rekordu
    FETCH NEXT FROM ema_cursor_2019 INTO @Data, @Nazwa, @Close_Price;
END;

-- Zamkniêcie kursora i zwolnienie zasobów
CLOSE ema_cursor_2019;
DEALLOCATE ema_cursor_2019;



-- Nastêpnym krokiem jest obliczenie krzywej RSI (Relative Strength Index)
-- Sprawdzenie i zamkniêcie istniej¹cego kursora, jeœli jest otwarty
-- Usuwanie tymczasowej tabeli #TempRSI, jeœli istnieje
-- Tworzenie nowej tymczasowej tabeli #TempRSI do przechowywania danych
-- Deklaracja zmiennych niezbêdnych do obliczeñ RSI
-- Kursor do iteracji przez rekordy od 2019-01-01, sortowanie wed³ug nazwy i daty
-- Otwarcie kursora i pobranie pierwszego rekordu
-- Iteracja w pêtli przez wszystkie rekordy, obliczaj¹c zyski i straty
-- Wartoœci s¹ wstawiane do tymczasowej tabeli #TempRSI
-- Zamkniêcie i dealokacja kursora po zakoñczeniu pêtli
-- U¿ycie CTE (Common Table Expressions) do obliczania œrednich zysków i strat
-- CTE Gains oblicza œrednie zyski z 12-dniowego okresu
-- CTE Losses oblicza œrednie straty z 12-dniowego okresu
-- CTE RSI_Calc oblicza wskaŸnik RSI na podstawie œrednich zysków i strat
-- Aktualizacja tabeli krzywe_kroczace2 wartoœciami RSI z CTE RSI_Calc
-- Usuniêcie tymczasowej tabeli #TempRSI po zakoñczeniu obliczeñ

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

-- Aktualizacja tabeli krzywe_kroczace2
UPDATE k
SET k.RSI = COALESCE(r.RSI, 0) -- Aby unikn¹æ NULL, przypisujemy 0
FROM krzywe_kroczace2 k
INNER JOIN RSI_Calc r ON k.Nazwa = r.Nazwa AND k.Data = r.Data;

-- Usuwanie tymczasowej tabeli
DROP TABLE #TempRSI;



-- Dodajê nowe kolumny EMA12 i EMA26 do tabeli krzywe_kroczace2
-- Deklarujê zmienne niezbêdne do obliczeñ EMA
-- Alpha to wspó³czynnik wyg³adzenia dla 12-dniowej i 26-dniowej EMA
-- Sprawdzam, czy istniej¹cy kursor jest otwarty i zamykam go, jeœli tak
-- Deklarujê nowy kursor do iteracji przez zamkniêcia cenowe po 2019-01-01
-- Otwieram kursor i pobieram pierwszy rekord
-- Inicjalizujê poprzednie wartoœci EMA12 i EMA26 pierwsz¹ cen¹ zamkniêcia po 2019-01-01
-- W pêtli, aktualizujê wartoœci EMA12 i EMA26 dla ka¿dego rekordu
-- Nowe wartoœci EMA12 i EMA26 zapisujê w tabeli krzywe_kroczace2
-- Pobieram kolejny rekord
-- Zamykam kursor i zwalniam zasoby
-- Obliczam wartoœci MACD jako ró¿nicê miêdzy EMA12 a EMA26
-- Aktualizujê tabelê krzywe_kroczace2 wartoœciami MACD dla rekordów po 2019-01-01

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

-- Sprawdzenie i zamkniêcie istniej¹cego kursora, jeœli jest otwarty
IF CURSOR_STATUS('global', 'ema_cursor_2019') <> -3
BEGIN
    CLOSE ema_cursor_2019;
    DEALLOCATE ema_cursor_2019;
END

-- Deklaracja nowego kursora do iteracji przez zamkniêcia cenowe po 2020-01-01
DECLARE ema_cursor_2019 CURSOR FOR
    SELECT Data_Date, Name, Close_Price
    FROM companies_quotes
    WHERE Data_Date >= '2019-01-01'
    ORDER BY Name, Data_Date;

OPEN ema_cursor_2020;

-- Pobranie pierwszego rekordu
FETCH NEXT FROM ema_cursor_2019 INTO @Data, @Nazwa, @Close_Price;

-- Inicjalizacja poprzednich wartoœci EMA12 i EMA26 pierwsz¹ cen¹ zamkniêcia po 2020-01-01
SELECT @Prev_EMA12 = Close_Price, @Prev_EMA26 = Close_Price
FROM companies_quotes
WHERE Data_Date = (SELECT MIN(Data_Date) FROM companies_quotes WHERE Name = @Nazwa AND Data_Date >= '2019-01-01')
      AND Name = @Nazwa;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Aktualizacja wartoœci EMA12 i EMA26
    SET @Prev_EMA12 = (@Close_Price * @Alpha12) + (@Prev_EMA12 * (1 - @Alpha12));
    SET @Prev_EMA26 = (@Close_Price * @Alpha26) + (@Prev_EMA26 * (1 - @Alpha26));

    -- Aktualizacja wartoœci EMA12 i EMA26 w tabeli krzywe_kroczace2
    UPDATE krzywe_kroczace2
    SET EMA12 = @Prev_EMA12, EMA26 = @Prev_EMA26
    WHERE Data = @Data AND Nazwa = @Nazwa;

    -- Pobranie kolejnego rekordu
    FETCH NEXT FROM ema_cursor_2020 INTO @Data, @Nazwa, @Close_Price;
END;

-- Zamkniêcie kursora i zwolnienie zasobów
CLOSE ema_cursor_2019;
DEALLOCATE ema_cursor_2019;



-- Obliczam wartoœci MACD jako ró¿nicê miêdzy EMA12 a EMA26
-- Aktualizujê tabelê krzywe_kroczace2 wartoœciami MACD dla rekordów po 2019-01-01
-- Poprzednie wyliczenia krzywych EMA12 i EMA26 by³y niezbêdne do obliczenia kolejnej bardzo przydatnej krzywej krocz¹cej MACD

UPDATE krzywe_kroczace2
SET MACD = EMA12 - EMA26
WHERE Data >= '2019-01-01';



-- Ten skrypt oblicza wartoœci krzywej krocz¹cej Signal na podstawie MACD (Moving Average Convergence Divergence).
-- Krzywa Signal jest 9-dniow¹ wyk³adnicz¹ œredni¹ krocz¹c¹ wartoœci MACD.
-- Algorytm dzia³a poprzez iteracjê przez rekordy w tabeli krzywe_kroczace2, obliczaj¹c Signal dla ka¿dego rekordu.
-- Ustalam alpha dla Signal jako EMA(9) z MACD, co pozwala na wyg³adzanie wartoœci MACD.
-- Deklarujê zmienne niezbêdne do przechowywania danych z kursora, w tym datê, nazwê spó³ki oraz wartoœci MACD i Signal.
-- Deklarujê kursor, który iteruje przez rekordy MACD w tabeli krzywe_kroczace2, sortuj¹c je wed³ug nazwy spó³ki i daty.
-- W pêtli, dla ka¿dego rekordu, jeœli to pierwszy rekord dla danej spó³ki, inicjalizujê wartoœæ Signal wartoœci¹ MACD.
-- Nastêpnie obliczam now¹ wartoœæ Signal jako wyg³adzenie miêdzy bie¿¹cym MACD a poprzedni¹ wartoœci¹ Signal.
-- Zaktualizowan¹ wartoœæ Signal zapisujê w tabeli krzywe_kroczace2.
-- Po zakoñczeniu iteracji zamykam i dealokujê kursor, aby zwolniæ zasoby.

-- Ustalenie alpha dla Signal jako EMA(9) z MACD
DECLARE @AlphaSignal DECIMAL(18, 4) = 2.0 / (9 + 1);

-- Deklaracja zmiennych kursora
DECLARE @Data DATE;
DECLARE @Nazwa VARCHAR(50);
DECLARE @MACD DECIMAL(18, 2);
DECLARE @PrevSignal DECIMAL(18, 2) = NULL; -- Startowy Signal jako NULL, aby znaleŸæ pierwsze MACD

-- Deklaracja kursora do iteracji przez wartoœci MACD
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
    -- Inicjalizacja pierwszego Signal wartoœci¹ pierwszego MACD
    IF @PrevSignal IS NULL
        SET @PrevSignal = @MACD;  -- Jeœli to pierwszy rekord dla danej spó³ki

    -- Obliczanie Signal na podstawie aktualnego MACD i poprzedniego Signal
    SET @PrevSignal = (@MACD * @AlphaSignal) + (@PrevSignal * (1 - @AlphaSignal));

    -- Aktualizacja wartoœci Signal w tabeli
    UPDATE krzywe_kroczace2
    SET Singal = @PrevSignal
    WHERE Data = @Data AND Nazwa = @Nazwa;

    -- Pobieranie kolejnego rekordu
    FETCH NEXT FROM signal_cursor INTO @Data, @Nazwa, @MACD;
END;

-- Zamkniêcie i dealokacja zasobów kursora
CLOSE signal_cursor;
DEALLOCATE signal_cursor;