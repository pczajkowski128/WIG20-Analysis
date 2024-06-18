-- Kolejnym krokiem jest �ci�gni�cie danych finansowych z Yahoo Finance -> Financials -> Balance Sheet do pliku excel w formacie .xlsx (dla ka�dej sp�ki z osobna)
-- Zamieniam przecinki na kropki, aby format by� odpowiedni dla sql management studio
-- Za pomoc� "SQL Server 2019 Import and Export Data (64-bit)" zaimportowa�em dane z excela ze wska�nikami finansowymi do mojej bazy danych sql 



-- Nast�pnie tworz� tabel�, kt�ra przechowuje wszystkie dane na temat wska�nik�w finansowych dla sp�ek

create table Wskazniki_Finansowe (
    Data DATE,
    Nazwa NVARCHAR(255),
    SumaAktyw�w DECIMAL(18, 2),
    SumaZobowi�za� DECIMAL(18, 2),
    Kapita�W�asny DECIMAL(18, 2),
    SumaD�ugu DECIMAL(18, 2),
    StanGot�wki DECIMAL(18, 2),
    WolnyPrzep�ywPieni�ny DECIMAL(18, 2),
    EmisjaAkcjiKapita�owych DECIMAL(18, 2),
    EmisjaD�ugu DECIMAL(18, 2),
    Sp�ataD�ugu DECIMAL(18, 2),
    WykupAkcjiKapita�owych DECIMAL(18, 2),
	WskaznikZadluzenia DECIMAL(18, 4),
    WskaznikZadluzeniaNetto DECIMAL(18, 4),
    RentownoscKapitaluWlasnego DECIMAL(18, 4),
    WskaznikPracujacegoKapitalu DECIMAL(18, 4)
);



-- Cztery ostatnie wska�niki nie s� to dane mo�liwe do �ci�gni�cia ze strony Yahoo Finance, tylko s� to wyniki oblicze�
-- Dzi�ki formu�om update+set uaktualni�em wybrane kolumny w tabeli i wykona�em dla nich opdowiednie obliczenia

UPDATE Wskazniki_Finansowe
SET WskaznikZadluzenia = SumaD�ugu / Kapita�W�asny;

UPDATE Wskazniki_Finansowe
SET WskaznikZadluzeniaNetto = (SumaD�ugu - StanGot�wki) / Kapita�W�asny;

UPDATE Wskazniki_Finansowe
SET RentownoscKapitaluWlasnego = WolnyPrzep�ywPieni�ny / Kapita�W�asny;

UPDATE Wskazniki_Finansowe
SET WskaznikPracujacegoKapitalu = (SumaAktyw�w - SumaZobowi�za�) / SumaAktyw�w;



-- Nast�pnie u�ywam klauzuli insert into, aby doda� wszystkie wcze�niej zaimportowane dane o wska�nikach finansowych sp�ek do mojej tabeli wsp�lnej dla wszystkich sp�ek

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM ALLEGRO_WSKAZNIKI;


INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM BUDIMEX_WSKAZNIKI;


INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM CD_PROJECT_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM CYFRPLSAT_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM DINO_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM JSW_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM KETY_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM KGHM_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM KRUK_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM ORANGEPL_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM PEPCO_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu], [WykupAkcjiKapita�owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM PKNORLEN_Wskazniki;


