-- Kolejnym krokiem jest ściągnięcie danych finansowych z Yahoo Finance -> Financials -> Cash Flow do pliku excel w formacie .xlsx (dla każdej spółki z osobna)
-- Zamieniam przecinki na kropki, aby format był odpowiedni dla sql management studio
-- Za pomocą "SQL Server 2019 Import and Export Data (64-bit)" importuję dane z excela z przepływami pieniężnymi do mojej bazy danych sql 



-- Następnie tworzę tabelę, która przechowuje wszystkie dane na temat przepływów pieniężnych dla wszystkich spółek z indeksu WIG20 (bez podziału na banki i pozostałe spółki)

CREATE TABLE PrzeplywyPieniezne (
    Data DATE,
    Nazwa NVARCHAR(100),
    PrzeplywyZDzialalnosciOperacyjnej DECIMAL(18, 2),
    PrzeplywyZDzialalnosciInwestycyjnej DECIMAL(18, 2),
    PrzeplywyZDzialalnosciFinansowej DECIMAL(18, 2),
    PozycjaKońcowaGotowki DECIMAL(18, 2),
    WydatkiInwestycyjne DECIMAL(18, 2),
    EmisjaDlugu DECIMAL(18, 2),
    SplataDlugu DECIMAL(18, 2),
    WolnyPrzeplywPieniezny DECIMAL(18, 2));



-- Następnie dodaję do mojej tabeli 3 nowe wskaźniki, które muszą zostać obliczone na różne sposoby

-- Dodaję kolumnę WskaznikPokryciaDlugu, którą obliczam jako iloraz przepływów z działalności operacyjnej do spłaty długu, tylko wtedy gdy spłata długu nie jest zerowa
ALTER TABLE PrzeplywyPieniezne ADD WskaznikPokryciaDlugu AS (PrzeplywyZDzialalnosciOperacyjnej / (CASE WHEN SplataDlugu <> 0 THEN SplataDlugu ELSE NULL END));

-- Kolumnę WskaznikReinwestycji obliczam jako iloraz wydatków inwestycyjnych do przepływów z działalności operacyjnej, tylko wtedy gdy przepływy z działalności operacyjnej nie są zerowe
ALTER TABLE PrzeplywyPieniezne ADD WskaznikReinwestycji AS (WydatkiInwestycyjne / (CASE WHEN PrzeplywyZDzialalnosciOperacyjnej <> 0 THEN PrzeplywyZDzialalnosciOperacyjnej ELSE NULL END));

-- Kolumnę WskaznikDywidendy obliczam jako iloraz przepływów z działalności finansowej do emisji długu, tylko wtedy gdy emisja długu nie jest zerowa
ALTER TABLE PrzeplywyPieniezne ADD WskaznikDywidendy AS (PrzeplywyZDzialalnosciFinansowej / NULLIF(EmisjaDlugu, 0));



-- Następnie używam polecenia insert into, aby dodać wszystkie wcześniej zaimportowane dane o przpeływach pieniężnych do tabeli zawierające dane wszystkich spółek z WIG20

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKońcowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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




