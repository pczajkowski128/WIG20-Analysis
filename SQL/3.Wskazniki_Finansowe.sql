-- Kolejnym krokiem jest œci¹gniêcie danych finansowych z Yahoo Finance -> Financials -> Balance Sheet do pliku excel w formacie .xlsx (dla ka¿dej spó³ki z osobna)
-- Zamieniam przecinki na kropki, aby format by³ odpowiedni dla sql management studio
-- Za pomoc¹ "SQL Server 2019 Import and Export Data (64-bit)" zaimportowa³em dane z excela ze wskaŸnikami finansowymi do mojej bazy danych sql 



-- Nastêpnie tworzê tabelê, która przechowuje wszystkie dane na temat wskaŸników finansowych dla spó³ek

create table Wskazniki_Finansowe (
    Data DATE,
    Nazwa NVARCHAR(255),
    SumaAktywów DECIMAL(18, 2),
    SumaZobowi¹zañ DECIMAL(18, 2),
    Kapita³W³asny DECIMAL(18, 2),
    SumaD³ugu DECIMAL(18, 2),
    StanGotówki DECIMAL(18, 2),
    WolnyPrzep³ywPieniê¿ny DECIMAL(18, 2),
    EmisjaAkcjiKapita³owych DECIMAL(18, 2),
    EmisjaD³ugu DECIMAL(18, 2),
    Sp³ataD³ugu DECIMAL(18, 2),
    WykupAkcjiKapita³owych DECIMAL(18, 2),
	WskaznikZadluzenia DECIMAL(18, 4),
    WskaznikZadluzeniaNetto DECIMAL(18, 4),
    RentownoscKapitaluWlasnego DECIMAL(18, 4),
    WskaznikPracujacegoKapitalu DECIMAL(18, 4)
);



-- Cztery ostatnie wskaŸniki nie s¹ to dane mo¿liwe do œci¹gniêcia ze strony Yahoo Finance, tylko s¹ to wyniki obliczeñ
-- Dziêki formu³om update+set uaktualni³em wybrane kolumny w tabeli i wykona³em dla nich opdowiednie obliczenia

UPDATE Wskazniki_Finansowe
SET WskaznikZadluzenia = SumaD³ugu / Kapita³W³asny;

UPDATE Wskazniki_Finansowe
SET WskaznikZadluzeniaNetto = (SumaD³ugu - StanGotówki) / Kapita³W³asny;

UPDATE Wskazniki_Finansowe
SET RentownoscKapitaluWlasnego = WolnyPrzep³ywPieniê¿ny / Kapita³W³asny;

UPDATE Wskazniki_Finansowe
SET WskaznikPracujacegoKapitalu = (SumaAktywów - SumaZobowi¹zañ) / SumaAktywów;



-- Nastêpnie u¿ywam klauzuli insert into, aby dodaæ wszystkie wczeœniej zaimportowane dane o wskaŸnikach finansowych spó³ek do mojej tabeli wspólnej dla wszystkich spó³ek

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM ALLEGRO_WSKAZNIKI;


INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM BUDIMEX_WSKAZNIKI;


INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM CD_PROJECT_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM CYFRPLSAT_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM DINO_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM JSW_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM KETY_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM KGHM_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM KRUK_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM ORANGEPL_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM PEPCO_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu], [WykupAkcjiKapita³owych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM PKNORLEN_Wskazniki;


