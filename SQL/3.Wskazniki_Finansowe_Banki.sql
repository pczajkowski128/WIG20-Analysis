-- Kolejnym krokiem jest ściągnięcie danych finansowych z Yahoo Finance -> Financials -> Balance Sheet do pliku excel w formacie .xlsx (dla każdego banku z osobna)
-- Zamieniam przecinki na kropki, aby format był odpowiedni dla sql management studio
-- Za pomocą "SQL Server 2019 Import and Export Data (64-bit)" importuję dane z excela ze wskaźnikami finansowymi dla banków do mojej bazy danych sql 
create table Wskazniki_Finansowe_Banki (
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
	WskaznikZadluzenia DECIMAL(18, 4),
    WskaznikZadluzeniaNetto DECIMAL(18, 4),
    RentownoscKapitaluWlasnego DECIMAL(18, 4),
    WskaznikPracujacegoKapitalu DECIMAL(18, 4)
);
-- Następnie tworzę tabelę, która przechowuje wszystkie dane na temat wskaźników finansowych dla banków
-- Cztery ostatnie wskaźniki nie są to dane możliwe do ściągnięcia ze strony Yahoo Finance, tylko są to wyniki obliczeń
-- Dzięki klauzuli update+set uaktualniłem wybrane kolumny w tabeli i ustawiłem dla nich opdowiednie obliczenia
UPDATE Wskazniki_Finansowe_Banki
SET WskaznikZadluzenia = SumaZobowiązań / SumaAktywów;

UPDATE Wskazniki_Finansowe_Banki
SET WskaznikZadluzeniaNetto = (SumaDługu - StanGotówki) / KapitałWłasny;

UPDATE Wskazniki_Finansowe_Banki
SET RentownoscKapitaluWlasnego = WolnyPrzepływPieniężny / KapitałWłasny;

UPDATE Wskazniki_Finansowe_Banki
SET WskaznikPracujacegoKapitalu = (SumaAktywów - SumaZobowiązań) / SumaAktywów;

-- Następnie używam klauzuli insert into, aby dodać wszystkie wcześniej zaimportowane dane o wskaźnikach finansowych banków do mojej tabeli wspólnej dla wszystkich banków
INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM ALIOR_BANK_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM MBANK_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM PEKAO_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM PKOBP_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM PZU_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktywów], [SumaZobowiązań], [KapitałWłasny], [SumaDługu], [StanGotówki], [WolnyPrzepływPieniężny],
[EmisjaAkcjiKapitałowych], [EmisjaDługu], [SpłataDługu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM SANPL_Wskazniki;