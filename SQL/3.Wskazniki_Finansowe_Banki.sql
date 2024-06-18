-- Kolejnym krokiem jest �ci�gni�cie danych finansowych z Yahoo Finance -> Financials -> Balance Sheet do pliku excel w formacie .xlsx (dla ka�dego banku z osobna)
-- Zamieniam przecinki na kropki, aby format by� odpowiedni dla sql management studio
-- Za pomoc� "SQL Server 2019 Import and Export Data (64-bit)" importuj� dane z excela ze wska�nikami finansowymi dla bank�w do mojej bazy danych sql 
create table Wskazniki_Finansowe_Banki (
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
	WskaznikZadluzenia DECIMAL(18, 4),
    WskaznikZadluzeniaNetto DECIMAL(18, 4),
    RentownoscKapitaluWlasnego DECIMAL(18, 4),
    WskaznikPracujacegoKapitalu DECIMAL(18, 4)
);
-- Nast�pnie tworz� tabel�, kt�ra przechowuje wszystkie dane na temat wska�nik�w finansowych dla bank�w
-- Cztery ostatnie wska�niki nie s� to dane mo�liwe do �ci�gni�cia ze strony Yahoo Finance, tylko s� to wyniki oblicze�
-- Dzi�ki klauzuli update+set uaktualni�em wybrane kolumny w tabeli i ustawi�em dla nich opdowiednie obliczenia
UPDATE Wskazniki_Finansowe_Banki
SET WskaznikZadluzenia = SumaZobowi�za� / SumaAktyw�w;

UPDATE Wskazniki_Finansowe_Banki
SET WskaznikZadluzeniaNetto = (SumaD�ugu - StanGot�wki) / Kapita�W�asny;

UPDATE Wskazniki_Finansowe_Banki
SET RentownoscKapitaluWlasnego = WolnyPrzep�ywPieni�ny / Kapita�W�asny;

UPDATE Wskazniki_Finansowe_Banki
SET WskaznikPracujacegoKapitalu = (SumaAktyw�w - SumaZobowi�za�) / SumaAktyw�w;

-- Nast�pnie u�ywam klauzuli insert into, aby doda� wszystkie wcze�niej zaimportowane dane o wska�nikach finansowych bank�w do mojej tabeli wsp�lnej dla wszystkich bank�w
INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM ALIOR_BANK_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM MBANK_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM PEKAO_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM PKOBP_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM PZU_Wskazniki;

INSERT INTO Wskazniki_Finansowe_Banki ([Data], Nazwa, [SumaAktyw�w], [SumaZobowi�za�], [Kapita�W�asny], [SumaD�ugu], [StanGot�wki], [WolnyPrzep�ywPieni�ny],
[EmisjaAkcjiKapita�owych], [EmisjaD�ugu], [Sp�ataD�ugu])
SELECT Data, Nazwa, [Total Assets], [Total Liabilities Net Minority Interest], [Total Equity Gross Minority Inter],
[Total Debt], [End Cash Position], [Free Cash Flow], [Issuance of Capital Stock], [Issuance of Debt], [Repayment of Debt]
FROM SANPL_Wskazniki;