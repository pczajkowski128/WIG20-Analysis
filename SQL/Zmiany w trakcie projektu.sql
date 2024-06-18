-- Podczas �ci�gania danych z Yahoo Finance napotka�em kilka problem�w, kt�re musia�em naprawi�
-- Pierwszym i chyba najpowa�niejszym by�a sytuacja gdy po zaczytaniu wszystkich danych do companies_quotes oraz utworzeniu krzywych krocz�cych zauwa�y�em, �e dane dla sp�ki DINO s� w warto�ciach NULL
-- Musia�em ponownie pobra� dane z internetu i zaaplikowa� je do mojej bazy danych

INSERT INTO companies_quotes (Name, Data_Date, Open_Price, Highest_Price, Lowest_Price, Close_Price, Adj_Close_Price, Volume)
SELECT Name, Date,
       CAST([Open] AS DECIMAL(10, 4)),
       CAST([High] AS DECIMAL(10, 4)),
       CAST([Low] AS DECIMAL(10, 4)),
       CAST([Close] AS DECIMAL(10, 4)),
       CAST([Adj Close] AS DECIMAL(10, 4)),
       CAST(Volume AS BIGINT)
FROM [Dino-Volume];



-- Pomimo zaczytania nowych danych dla tej sp�ki nadal brakowa�o niekt�rych warto�ci. 
-- Aby wyczy�ci� dane musia�em usun�� niektore wiersze
-- Poni�ej podaj� przyk�ad, jak usun��em rekordy z warto�ci� NULL dla konkretnej daty.

delete from [Dino-Volumen]
where Date = '2017-05-24'



-- Podczas ��czenia tabeli z companies_quotes wyst�powa� problem z niepoprawnym typem danych dla obrotu sp�ki
-- Sprawdzam, kt�re rekordy maj� warto�� Volume, kt�rej nie mo�na skonwertowa� na typ BIGINT, co mo�e wskazywa� na nieprawid�owe dane
-- Wy�wietlam te rekordy, aby m�c je przeanalizowa� i ewentualnie poprawi�

SELECT Volume FROM [Dino-Volumen] WHERE TRY_CAST(Volume AS BIGINT) IS NULL AND Volume IS NOT NULL;



-- Aktualizuj� warto�� Volume, konwertuj�c j� na typ BIGINT po zaokr�gleniu do najbli�szej liczby ca�kowitej
-- Zapewniam w ten spos�b, �e wszystkie warto�ci Volume s� poprawnie zapisane jako liczby ca�kowite

UPDATE [Dino-Volumen]
SET Volume = CAST(ROUND(Volume, 0) AS BIGINT);



-- Sprawdzam, kt�re rekordy maj� warto�� w kolumnie Adj Close, kt�ra nie jest liczb�
-- Wy�wietlam te rekordy, aby m�c je przeanalizowa� i ewentualnie poprawi�

SELECT *
FROM [Dino-Volumen]
WHERE ISNUMERIC([Adj Close]) = 0;



-- Dla wi�kszo�ci sp�ek musia�em aktualizowa� nazwy, aby by�y sp�jne
-- Inaczej podczas wizualizacji w power BI napotyka�em b��dy
-- Poni�ej podaj� przyk�ad aktualizacji nazwy sp�ki Cyfrowy Polsat, aby by�a zgodna ze standardem u�ywanym w projekcie

update CYFRPLSAT_Finanse
set Nazwa = 'CYFRPLSAT'
where Nazwa = 'Cyfrplsat'



-- Niekt�re dane jak na przyk�ad te poni�ej dla Allegro pobiera�y si� z warto�ciami NULL chocia� na stronie by�y podane warto�ci
-- Wtedy by�yem zmuszony r�cznie aktualizowa� rekordy w tabeli
-- Poni�ej podaj� przyk�ad aktualizacji dla sp�ki Allegro, ustawiaj�c poprawn� warto�� zysku netto dla akcjonariuszy

update ALLEGRO_Finanse
set [Zysk netto dla akcjonariuszy] = -335335.18
where [Zysk netto dla akcjonariuszy] is NULL;



-- Aktualizuj� warto�� Volume w tabeli companies_quotes na podstawie warto�ci z tabeli Dino-Volumen
-- Do��czam tabel� Dino-Volumen do companies_quotes, aby dopasowa� odpowiednie rekordy na podstawie daty i nazwy sp�ki
-- Upewniam si�, �e aktualizuj� tylko te rekordy, gdzie warto�� Volume jest NULL lub niezgodna

UPDATE cq
SET cq.Volume = dv.Volume
FROM companies_quotes cq
JOIN [Dino-Volumen] dv ON cq.Data_Date = dv.Date AND cq.Name = 'DINO'
WHERE cq.Volume IS NULL OR cq.Volume <> dv.Volume;



--  Poni�ej przedstawiam przyk�ad jak sprawdza�em kolumny w tabeli companies_quotes, aby upewni� si�, �e struktury tabeli s� zgodne z oczekiwaniami

EXEC sp_columns 'companies_quotes';



-- Nazwy tabel po zaimportowaniu ich do mojej bazy sql za pomoc� "SQL Server 2019 Import and Export Data (64-bit)" nie by�y zgodne moimi oczekiwaniami
-- Poni�ej przyk�ad zmiany nazwy tabeli -- Aby u�atwi� prac� z danymi, zmieniam nazwy tabel na bardziej przejrzyste
-- Poni�ej przyk�ad zmiany nazwy tabeli

exec sp_rename 'Arkusz1$', 'SANPL_Przeplyw'



-- Ostatnim przyk�adem poprawek b�dzie wstawienie danych do tabeli KPI, obliczaj�c odpowiednie wska�niki finansowe
-- Robi�em to, aby zapewni�, �e tabela KPI zawiera najnowsze i dok�adne informacje finansowe dla ka�dej sp�ki
-- Robi�em to w taki spos�b za pomoc� klauzul SELECT, CASE i JOIN, aby po��czy� dane z tabel Dane_Finansowe oraz Wska�niki_Finansowe,
-- Nast�pnie obliczam wska�niki takie jak Rentowno�� Kapita�u W�asnego, Wska�nik Zad�u�enia Netto, Wolny Przep�yw Pieni�ny oraz Zysk na Akcj� Rozrzedzon�
-- Wstawiam dane do tabeli KPI, obliczaj�c odpowiednie wska�niki finansowe na podstawie danych z tabeli Dane_Finansowe oraz Wska�niki_Finansowe
-- U�ywam klauzul CASE, aby unikn�� dzielenia przez zero i ustawiam warto�� NULL, je�li Kapita� W�asny jest r�wny zero
-- Filtruj� dane, aby obejmowa�y tylko te sp�ki, kt�re s� obecne zar�wno w tabeli Dane_Finansowe, jak i Wska�niki_Finansowe

INSERT INTO KPI (Data, Nazwa, RentownoscKapitaluWlasnego, WskaznikZadluzeniaNetto, WolnyPrzeplywPieniezny, ZyskNaAkcjeRozrzedzone)
SELECT
    df.DataRaportu,
    df.Nazwa,
    CASE WHEN wf.Kapita�W�asny != 0 THEN df.ZyskNettoDlaAkcjonariuszy / wf.Kapita�W�asny ELSE NULL END AS RentownoscKapitaluWlasnego,
    CASE WHEN wf.Kapita�W�asny != 0 THEN (wf.SumaD�ugu - wf.StanGot�wki) / wf.Kapita�W�asny ELSE NULL END AS WskaznikZadluzeniaNetto,
    wf.WolnyPrzep�ywPieni�ny,
    df.ZyskNaAkcjeRozrzedzone
FROM
    Dane_Finansowe df
JOIN
    Wskazniki_Finansowe wf ON df.Nazwa = wf.Nazwa AND df.DataRaportu = wf.Data
WHERE
    df.Nazwa IN ('DINO');



-- Usuwam rekordy dla sp�ki DINO z tabeli KPI, aby unikn�� dublowania danych
-- Robi�em to, aby zapewni�, �e tabela KPI zawiera tylko unikalne i dok�adne informacje dla ka�dej sp�ki.
-- Robi�em to w taki spos�b za pomoc� klauzuli DELETE, aby usun�� wszystkie rekordy z tabeli KPI, gdzie nazwa sp�ki to 'DINO'

delete from KPI
where Nazwa = 'DINO';


-- Sprawdzanie mediany dla Allegro
SELECT dbo.Median('ALLEGRO', '2020-10-13', -1) AS DayChange,
       dbo.Median('ALLEGRO', '2020-10-13', -7) AS WeekChange,
       dbo.Median('ALLEGRO', '2020-10-13', -30) AS MonthChange
