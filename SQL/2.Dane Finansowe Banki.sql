-- Kolejnym krokiem jest �ci�gni�cie danych finansowych z Yahoo Finance -> Financials -> Income Statement do pliku excel w formacie .xlsx (dla ka�dego banku z osobna)
-- Zamieniam przecinki na kropki, aby format by� odpowiedni dla sql management studio
-- Za pomoc� "SQL Server 2019 Import and Export Data (64-bit)" importuj� dane z excela z danymi finansowymi dla bank�w do mojej bazy danych sql 
create TABLE Dane_Finansowe_Banki (
    DataRaportu DATE,
	Nazwa varchar(50),
    PrzychodyOgolem DECIMAL(18,2),
    ZyskPrzedOpodatkowaniem DECIMAL(18,2),
    ZyskNettoAkcjonariuszy DECIMAL(18,2),
    ZyskNaAkcjePodstawowe DECIMAL(18,2),
    ZyskNaAkcjeRozrzedzone DECIMAL(18,2),
    ZnormalizowanyZysk DECIMAL(18,2),
    OdliczeniaAmortyzacyjne DECIMAL(18,2),
    StawkaPodatkowa DECIMAL(18,2)
);
-- Nast�pnie tworz� tabel�, kt�ra przechowuje wszystkie dane finansowe dla ka�dej ze sp�ek bankowych i wprowadzam je do tej tabeli poprzez klauzule insert into

INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody og�em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk�ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcj� podstawow�] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcj� rozrzedzon�] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla oblicze�] AS StawkaPodatkowa
FROM ALIOR_BANK_Finanse;


INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody og�em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk�ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcj� podstawow�] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcj� rozrzedzon�] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla oblicze�] AS StawkaPodatkowa
FROM MBANK_Finanse;

INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody og�em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk�ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcj� podstawow�] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcj� rozrzedzon�] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla oblicze�] AS StawkaPodatkowa
FROM PEKAO_Finanse;


INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody og�em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk�ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcj� podstawow�] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcj� rozrzedzon�] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla oblicze�] AS StawkaPodatkowa
FROM PKOBP_Finanse;

INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody og�em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk�ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcj� podstawow�] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcj� rozrzedzon�] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla oblicze�] AS StawkaPodatkowa
FROM PZU_Finanse;

INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody og�em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk�ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcj� podstawow�] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcj� rozrzedzon�] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla oblicze�] AS StawkaPodatkowa
FROM SANPL_Finanse;



