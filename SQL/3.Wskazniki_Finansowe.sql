-- Kolejnym krokiem jest ściągnięcie danych finansowych z Yahoo Finance -> Financials -> Balance Sheet do pliku excel w formacie .xlsx (dla każdej spółki z osobna)
-- Zamieniam przecinki na kropki, aby format był odpowiedni dla sql management studio
-- Za pomocą "SQL Server 2019 Import and Export Data (64-bit)" zaimportowałem dane z excela ze wskaźnikami finansowymi do mojej bazy danych sql 



-- Następnie tworzę tabelę, która przechowuje wszystkie dane na temat wskaźników finansowych dla spółek

create table Wskazniki_Finansowe (
    Data DATE,
    Nazwa NVARCHAR(255),
    SumaAktywów DECIMAL(18, 2),
    SumaZobowiązań DECIMAL(18, 2),
    KapitałWłasny DECIMAL(18, 2),
    SumaDługu DECIMAL(18, 2),
    StanGotówki DECIMAL(18, 2),
    WolnyPrzepływPieniężny DECIMAL(18, 2),
    EmisjaAkcjiKapitałowych DECIMAL(18, 2),
    EmisjaDługu DECIMAL(18, 2),
    SpłataDługu DECIMAL(18, 2),
    WykupAkcjiKapitałowych DECIMAL(18, 2),
	WskaznikZadluzenia DECIMAL(18, 4),
    WskaznikZadluzeniaNetto DECIMAL(18, 4),
    RentownoscKapitaluWlasnego DECIMAL(18, 4),
    WskaznikPracujacegoKapitalu DECIMAL(18, 4)
);



-- Cztery ostatnie wskaźniki nie są to dane możliwe do ściągnięcia ze strony Yahoo Finance, tylko są to wyniki obliczeń
-- Dzięki formułom update+set uaktualniłem wybrane kolumny w tabeli i wykonałem dla nich opdowiednie obliczenia

UPDATE Wskazniki_Finansowe
SET WskaznikZadluzenia = SumaDługu / KapitałWłasny;

UPDATE Wskazniki_Finansowe
SET WskaznikZadluzeniaNetto = (SumaDługu - StanGotówki) / KapitałWłasny;

UPDATE Wskazniki_Finansowe
SET RentownoscKapitaluWlasnego = WolnyPrzepływPieniężny / KapitałWłasny;

UPDATE Wskazniki_Finansowe
SET WskaznikPracujacegoKapitalu = (SumaAktywów - SumaZobowiązań) / SumaAktywów;



-- Następnie używam klauzuli insert into, aby dodać wszystkie wcześniej zaimportowane dane o wskaźnikach finansowych spółek do mojej tabeli wspólnej dla wszystkich spółek

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM ALLEGRO_WSKAZNIKI;


INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM BUDIMEX_WSKAZNIKI;


INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM CD_PROJECT_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM CYFRPLSAT_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM DINO_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM JSW_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM KETY_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM KGHM_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM KRUK_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM ORANGEPL_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM PEPCO_Wskazniki;

INSERT INTO Wskazniki_Finansowe ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu], [WykupAkcjiKapitałowych])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt], [Repurchase of Capital Stock]
FROM PKNORLEN_Wskazniki;


