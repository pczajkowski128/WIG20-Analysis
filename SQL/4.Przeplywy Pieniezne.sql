-- Kolejnym krokiem jest œci¹gniêcie danych finansowych z Yahoo Finance -> Financials -> Cash Flow do pliku excel w formacie .xlsx (dla ka¿dej spó³ki z osobna)
-- Zamieniam przecinki na kropki, aby format by³ odpowiedni dla sql management studio
-- Za pomoc¹ "SQL Server 2019 Import and Export Data (64-bit)" importujê dane z excela z przep³ywami pieniê¿nymi do mojej bazy danych sql 



-- Nastêpnie tworzê tabelê, która przechowuje wszystkie dane na temat przep³ywów pieniê¿nych dla wszystkich spó³ek z indeksu WIG20 (bez podzia³u na banki i pozosta³e spó³ki)

CREATE TABLE PrzeplywyPieniezne (
    Data DATE,
    Nazwa NVARCHAR(100),
    PrzeplywyZDzialalnosciOperacyjnej DECIMAL(18, 2),
    PrzeplywyZDzialalnosciInwestycyjnej DECIMAL(18, 2),
    PrzeplywyZDzialalnosciFinansowej DECIMAL(18, 2),
    PozycjaKoñcowaGotowki DECIMAL(18, 2),
    WydatkiInwestycyjne DECIMAL(18, 2),
    EmisjaDlugu DECIMAL(18, 2),
    SplataDlugu DECIMAL(18, 2),
    WolnyPrzeplywPieniezny DECIMAL(18, 2));



-- Nastêpnie dodajê do mojej tabeli 3 nowe wskaŸniki, które musz¹ zostaæ obliczone na ró¿ne sposoby

-- Dodajê kolumnê WskaznikPokryciaDlugu, któr¹ obliczam jako iloraz przep³ywów z dzia³alnoœci operacyjnej do sp³aty d³ugu, tylko wtedy gdy sp³ata d³ugu nie jest zerowa
ALTER TABLE PrzeplywyPieniezne ADD WskaznikPokryciaDlugu AS (PrzeplywyZDzialalnosciOperacyjnej / (CASE WHEN SplataDlugu <> 0 THEN SplataDlugu ELSE NULL END));

-- Kolumnê WskaznikReinwestycji obliczam jako iloraz wydatków inwestycyjnych do przep³ywów z dzia³alnoœci operacyjnej, tylko wtedy gdy przep³ywy z dzia³alnoœci operacyjnej nie s¹ zerowe
ALTER TABLE PrzeplywyPieniezne ADD WskaznikReinwestycji AS (WydatkiInwestycyjne / (CASE WHEN PrzeplywyZDzialalnosciOperacyjnej <> 0 THEN PrzeplywyZDzialalnosciOperacyjnej ELSE NULL END));

-- Kolumnê WskaznikDywidendy obliczam jako iloraz przep³ywów z dzia³alnoœci finansowej do emisji d³ugu, tylko wtedy gdy emisja d³ugu nie jest zerowa
ALTER TABLE PrzeplywyPieniezne ADD WskaznikDywidendy AS (PrzeplywyZDzialalnosciFinansowej / NULLIF(EmisjaDlugu, 0));



-- Nastêpnie u¿ywam polecenia insert into, aby dodaæ wszystkie wczeœniej zaimportowane dane o przpe³ywach pieniê¿nych do tabeli zawieraj¹ce dane wszystkich spó³ek z WIG20

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM ALIOR_BANK_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM ALLEGRO_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM BUDIMEX_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM CD_PROJECT_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM CYFRPLSAT_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM DINO_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM JSW_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM KETY_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM KRUK_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM LPP_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM MBANK_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM ORANGEPL_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM PEKAO_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM PEPCO_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM PGE_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM PKNORLEN_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM PKOBP_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM PZU_Przeplyw

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKoñcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
SELECT 
    Data,
    Nazwa,
    [Operating Cash Flow],
    [Investing Cash Flow],
    [Financing Cash Flow],
    [End Cash Position],
    [Capital Expenditure],
    [Issuance of Debt],
    [Repayment of Debt],
    [Free Cash Flow]
FROM SANPL_Przeplyw




