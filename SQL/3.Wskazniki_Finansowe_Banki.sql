-- Kolejnym krokiem jest œci¹gniêcie danych finansowych z Yahoo Finance -> Financials -> Balance Sheet do pliku excel w formacie .xlsx (dla ka¿dego banku z osobna)
-- Zamieniam przecinki na kropki, aby format by³ odpowiedni dla sql management studio
-- Za pomoc¹ "SQL Server 2019 Import and Export Data (64-bit)" importujê dane z excela ze wskaŸnikami finansowymi dla banków do mojej bazy danych sql 
create table Wskazniki_Finansowe_Banki (
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
	WskaznikZadluzenia DECIMAL(18, 4),
    WskaznikZadluzeniaNetto DECIMAL(18, 4),
    RentownoscKapitaluWlasnego DECIMAL(18, 4),
    WskaznikPracujacegoKapitalu DECIMAL(18, 4)
);
-- Nastêpnie tworzê tabelê, która przechowuje wszystkie dane na temat wskaŸników finansowych dla banków
-- Cztery ostatnie wskaŸniki nie s¹ to dane mo¿liwe do œci¹gniêcia ze strony Yahoo Finance, tylko s¹ to wyniki obliczeñ
-- Dziêki klauzuli update+set uaktualni³em wybrane kolumny w tabeli i ustawi³em dla nich opdowiednie obliczenia
UPDATE Wskazniki_Finansowe_Banki
SET WskaznikZadluzenia = SumaZobowi¹zañ / SumaAktywów;

UPDATE Wskazniki_Finansowe_Banki
SET WskaznikZadluzeniaNetto = (SumaD³ugu - StanGotówki) / Kapita³W³asny;

UPDATE Wskazniki_Finansowe_Banki
SET RentownoscKapitaluWlasnego = WolnyPrzep³ywPieniê¿ny / Kapita³W³asny;

UPDATE Wskazniki_Finansowe_Banki
SET WskaznikPracujacegoKapitalu = (SumaAktywów - SumaZobowi¹zañ) / SumaAktywów;

-- Nastêpnie u¿ywam klauzuli insert into, aby dodaæ wszystkie wczeœniej zaimportowane dane o wskaŸnikach finansowych banków do mojej tabeli wspólnej dla wszystkich banków
INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM ALIOR_BANK_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM MBANK_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM PEKAO_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM PKOBP_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM PZU_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowi¹zañ], [Kapita³W³asny], [SumaD³ugu], [StanGotówki], [WolnyPrzep³ywPieniê¿ny],
[EmisjaAkcjiKapita³owych], [EmisjaD³ugu], [Sp³ataD³ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM SANPL_Wskazniki;