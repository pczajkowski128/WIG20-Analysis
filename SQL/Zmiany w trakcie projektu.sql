-- Podczas œci¹gania danych z Yahoo Finance napotka³em kilka problemów, które musia³em naprawiæ
-- Pierwszym i chyba najpowa¿niejszym by³a sytuacja gdy po zaczytaniu wszystkich danych do companies_quotes oraz utworzeniu krzywych krocz¹cych zauwa¿y³em, ¿e dane dla spó³ki DINO s¹ w wartoœciach NULL
-- Musia³em ponownie pobraæ dane z internetu i zaaplikowaæ je do mojej bazy danych

INSERT INTO companies_quotes (Name, Data_Date, Open_Price, Highest_Price, Lowest_Price, Close_Price, Adj_Close_Price, Volume)
SELECT Name, Date,
       CAST([Open] AS DECIMAL(10, 4)),
       CAST([High] AS DECIMAL(10, 4)),
       CAST([Low] AS DECIMAL(10, 4)),
       CAST([Close] AS DECIMAL(10, 4)),
       CAST([Adj Close] AS DECIMAL(10, 4)),
       CAST(Volume AS BIGINT)
FROM [Dino-Volume];



-- Pomimo zaczytania nowych danych dla tej spó³ki nadal brakowa³o niektórych wartoœci. 
-- Aby wyczyœciæ dane musia³em usun¹æ niektore wiersze
-- Poni¿ej podajê przyk³ad, jak usun¹³em rekordy z wartoœci¹ NULL dla konkretnej daty.

delete from [Dino-Volumen]
where Date = '2017-05-24'



-- Podczas ³¹czenia tabeli z companies_quotes wystêpowa³ problem z niepoprawnym typem danych dla obrotu spó³ki
-- Sprawdzam, które rekordy maj¹ wartoœæ Volume, której nie mo¿na skonwertowaæ na typ BIGINT, co mo¿e wskazywaæ na nieprawid³owe dane
-- Wyœwietlam te rekordy, aby móc je przeanalizowaæ i ewentualnie poprawiæ

SELECT Volume FROM [Dino-Volumen] WHERE TRY_CAST(Volume AS BIGINT) IS NULL AND Volume IS NOT NULL;



-- Aktualizujê wartoœæ Volume, konwertuj¹c j¹ na typ BIGINT po zaokr¹gleniu do najbli¿szej liczby ca³kowitej
-- Zapewniam w ten sposób, ¿e wszystkie wartoœci Volume s¹ poprawnie zapisane jako liczby ca³kowite

UPDATE [Dino-Volumen]
SET Volume = CAST(ROUND(Volume, 0) AS BIGINT);



-- Sprawdzam, które rekordy maj¹ wartoœæ w kolumnie Adj Close, która nie jest liczb¹
-- Wyœwietlam te rekordy, aby móc je przeanalizowaæ i ewentualnie poprawiæ

SELECT *
FROM [Dino-Volumen]
WHERE ISNUMERIC([Adj Close]) = 0;



-- Dla wiêkszoœci spó³ek musia³em aktualizowaæ nazwy, aby by³y spójne
-- Inaczej podczas wizualizacji w power BI napotyka³em b³êdy
-- Poni¿ej podajê przyk³ad aktualizacji nazwy spó³ki Cyfrowy Polsat, aby by³a zgodna ze standardem u¿ywanym w projekcie

update CYFRPLSAT_Finanse
set Nazwa = 'CYFRPLSAT'
where Nazwa = 'Cyfrplsat'



-- Niektóre dane jak na przyk³ad te poni¿ej dla Allegro pobiera³y siê z wartoœciami NULL chocia¿ na stronie by³y podane wartoœci
-- Wtedy by³yem zmuszony rêcznie aktualizowaæ rekordy w tabeli
-- Poni¿ej podajê przyk³ad aktualizacji dla spó³ki Allegro, ustawiaj¹c poprawn¹ wartoœæ zysku netto dla akcjonariuszy

update ALLEGRO_Finanse
set [Zysk netto dla akcjonariuszy] = -335335.18
where [Zysk netto dla akcjonariuszy] is NULL;



-- Aktualizujê wartoœæ Volume w tabeli companies_quotes na podstawie wartoœci z tabeli Dino-Volumen
-- Do³¹czam tabelê Dino-Volumen do companies_quotes, aby dopasowaæ odpowiednie rekordy na podstawie daty i nazwy spó³ki
-- Upewniam siê, ¿e aktualizujê tylko te rekordy, gdzie wartoœæ Volume jest NULL lub niezgodna

UPDATE cq
SET cq.Volume = dv.Volume
FROM companies_quotes cq
JOIN [Dino-Volumen] dv ON cq.Data_Date = dv.Date AND cq.Name = 'DINO'
WHERE cq.Volume IS NULL OR cq.Volume <> dv.Volume;



--  Poni¿ej przedstawiam przyk³ad jak sprawdza³em kolumny w tabeli companies_quotes, aby upewniæ siê, ¿e struktury tabeli s¹ zgodne z oczekiwaniami

EXEC sp_columns 'companies_quotes';



-- Nazwy tabel po zaimportowaniu ich do mojej bazy sql za pomoc¹ "SQL Server 2019 Import and Export Data (64-bit)" nie by³y zgodne moimi oczekiwaniami
-- Poni¿ej przyk³ad zmiany nazwy tabeli -- Aby u³atwiæ pracê z danymi, zmieniam nazwy tabel na bardziej przejrzyste
-- Poni¿ej przyk³ad zmiany nazwy tabeli

exec sp_rename 'Arkusz1$', 'SANPL_Przeplyw'



-- Ostatnim przyk³adem poprawek bêdzie wstawienie danych do tabeli KPI, obliczaj¹c odpowiednie wskaŸniki finansowe
-- Robi³em to, aby zapewniæ, ¿e tabela KPI zawiera najnowsze i dok³adne informacje finansowe dla ka¿dej spó³ki
-- Robi³em to w taki sposób za pomoc¹ klauzul SELECT, CASE i JOIN, aby po³¹czyæ dane z tabel Dane_Finansowe oraz WskaŸniki_Finansowe,
-- Nastêpnie obliczam wskaŸniki takie jak Rentownoœæ Kapita³u W³asnego, WskaŸnik Zad³u¿enia Netto, Wolny Przep³yw Pieniê¿ny oraz Zysk na Akcjê Rozrzedzon¹
-- Wstawiam dane do tabeli KPI, obliczaj¹c odpowiednie wskaŸniki finansowe na podstawie danych z tabeli Dane_Finansowe oraz WskaŸniki_Finansowe
-- U¿ywam klauzul CASE, aby unikn¹æ dzielenia przez zero i ustawiam wartoœæ NULL, jeœli Kapita³ W³asny jest równy zero
-- Filtrujê dane, aby obejmowa³y tylko te spó³ki, które s¹ obecne zarówno w tabeli Dane_Finansowe, jak i WskaŸniki_Finansowe

INSERT INTO KPI (Data, Nazwa, RentownoscKapitaluWlasnego, WskaznikZadluzeniaNetto, WolnyPrzeplywPieniezny, ZyskNaAkcjeRozrzedzone)
SELECT
    df.DataRaportu,
    df.Nazwa,
    CASE WHEN wf.Kapita³W³asny != 0 THEN df.ZyskNettoDlaAkcjonariuszy / wf.Kapita³W³asny ELSE NULL END AS RentownoscKapitaluWlasnego,
    CASE WHEN wf.Kapita³W³asny != 0 THEN (wf.SumaD³ugu - wf.StanGotówki) / wf.Kapita³W³asny ELSE NULL END AS WskaznikZadluzeniaNetto,
    wf.WolnyPrzep³ywPieniê¿ny,
    df.ZyskNaAkcjeRozrzedzone
FROM
    Dane_Finansowe df
JOIN
    Wskazniki_Finansowe wf ON df.Nazwa = wf.Nazwa AND df.DataRaportu = wf.Data
WHERE
    df.Nazwa IN ('DINO');



-- Usuwam rekordy dla spó³ki DINO z tabeli KPI, aby unikn¹æ dublowania danych
-- Robi³em to, aby zapewniæ, ¿e tabela KPI zawiera tylko unikalne i dok³adne informacje dla ka¿dej spó³ki.
-- Robi³em to w taki sposób za pomoc¹ klauzuli DELETE, aby usun¹æ wszystkie rekordy z tabeli KPI, gdzie nazwa spó³ki to 'DINO'

delete from KPI
where Nazwa = 'DINO';


-- Sprawdzanie mediany dla Allegro
SELECT dbo.Median('ALLEGRO', '2020-10-13', -1) AS DayChange,
       dbo.Median('ALLEGRO', '2020-10-13', -7) AS WeekChange,
       dbo.Median('ALLEGRO', '2020-10-13', -30) AS MonthChange
