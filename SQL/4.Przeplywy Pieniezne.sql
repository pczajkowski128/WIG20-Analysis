-- Kolejnym krokiem jest �ci�gni�cie danych finansowych z Yahoo Finance -> Financials -> Cash Flow do pliku excel w formacie .xlsx (dla ka�dej sp�ki z osobna)
-- Zamieniam przecinki na kropki, aby format by� odpowiedni dla sql management studio
-- Za pomoc� "SQL Server 2019 Import and Export Data (64-bit)" importuj� dane z excela z przep�ywami pieni�nymi do mojej bazy danych sql 



-- Nast�pnie tworz� tabel�, kt�ra przechowuje wszystkie dane na temat przep�yw�w pieni�nych dla wszystkich sp�ek z indeksu WIG20 (bez podzia�u na banki i pozosta�e sp�ki)

CREATE TABLE PrzeplywyPieniezne (
    Data DATE,
    Nazwa NVARCHAR(100),
    PrzeplywyZDzialalnosciOperacyjnej DECIMAL(18, 2),
    PrzeplywyZDzialalnosciInwestycyjnej DECIMAL(18, 2),
    PrzeplywyZDzialalnosciFinansowej DECIMAL(18, 2),
    PozycjaKo�cowaGotowki DECIMAL(18, 2),
    WydatkiInwestycyjne DECIMAL(18, 2),
    EmisjaDlugu DECIMAL(18, 2),
    SplataDlugu DECIMAL(18, 2),
    WolnyPrzeplywPieniezny DECIMAL(18, 2));



-- Nast�pnie dodaj� do mojej tabeli 3 nowe wska�niki, kt�re musz� zosta� obliczone na r�ne sposoby

-- Dodaj� kolumn� WskaznikPokryciaDlugu, kt�r� obliczam jako iloraz przep�yw�w z dzia�alno�ci operacyjnej do sp�aty d�ugu, tylko wtedy gdy sp�ata d�ugu nie jest zerowa
ALTER TABLE PrzeplywyPieniezne ADD WskaznikPokryciaDlugu AS (PrzeplywyZDzialalnosciOperacyjnej / (CASE WHEN SplataDlugu <> 0 THEN SplataDlugu ELSE NULL END));

-- Kolumn� WskaznikReinwestycji obliczam jako iloraz wydatk�w inwestycyjnych do przep�yw�w z dzia�alno�ci operacyjnej, tylko wtedy gdy przep�ywy z dzia�alno�ci operacyjnej nie s� zerowe
ALTER TABLE PrzeplywyPieniezne ADD WskaznikReinwestycji AS (WydatkiInwestycyjne / (CASE WHEN PrzeplywyZDzialalnosciOperacyjnej <> 0 THEN PrzeplywyZDzialalnosciOperacyjnej ELSE NULL END));

-- Kolumn� WskaznikDywidendy obliczam jako iloraz przep�yw�w z dzia�alno�ci finansowej do emisji d�ugu, tylko wtedy gdy emisja d�ugu nie jest zerowa
ALTER TABLE PrzeplywyPieniezne ADD WskaznikDywidendy AS (PrzeplywyZDzialalnosciFinansowej / NULLIF(EmisjaDlugu, 0));



-- Nast�pnie u�ywam polecenia insert into, aby doda� wszystkie wcze�niej zaimportowane dane o przpe�ywach pieni�nych do tabeli zawieraj�ce dane wszystkich sp�ek z WIG20

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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

INSERT INTO PrzeplywyPieniezne (Data, Nazwa, PrzeplywyZDzialalnosciOperacyjnej, PrzeplywyZDzialalnosciInwestycyjnej, PrzeplywyZDzialalnosciFinansowej, PozycjaKo�cowaGotowki, WydatkiInwestycyjne, EmisjaDlugu, SplataDlugu, WolnyPrzeplywPieniezny)
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




