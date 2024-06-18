-- Kolejnym krokiem jest œci¹gniêcie danych finansowych z Yahoo Finance -> Financials -> Income Statement do pliku excel w formacie .xlsx (dla ka¿dego banku z osobna)
-- Zamieniam przecinki na kropki, aby format by³ odpowiedni dla sql management studio
-- Za pomoc¹ "SQL Server 2019 Import and Export Data (64-bit)" importujê dane z excela z danymi finansowymi dla banków do mojej bazy danych sql 
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
-- Nastêpnie tworzê tabelê, która przechowuje wszystkie dane finansowe dla ka¿dej ze spó³ek bankowych i wprowadzam je do tej tabeli poprzez klauzule insert into

INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody ogó³em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk³ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcjê podstawow¹] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcjê rozrzedzon¹] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla obliczeñ] AS StawkaPodatkowa
FROM ALIOR_BANK_Finanse;


INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody ogó³em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk³ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcjê podstawow¹] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcjê rozrzedzon¹] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla obliczeñ] AS StawkaPodatkowa
FROM MBANK_Finanse;

INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody ogó³em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk³ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcjê podstawow¹] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcjê rozrzedzon¹] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla obliczeñ] AS StawkaPodatkowa
FROM PEKAO_Finanse;


INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody ogó³em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk³ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcjê podstawow¹] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcjê rozrzedzon¹] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla obliczeñ] AS StawkaPodatkowa
FROM PKOBP_Finanse;

INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody ogó³em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk³ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcjê podstawow¹] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcjê rozrzedzon¹] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla obliczeñ] AS StawkaPodatkowa
FROM PZU_Finanse;

INSERT INTO Dane_Finansowe_Banki (DataRaportu, Nazwa, PrzychodyOgolem, ZyskPrzedOpodatkowaniem, ZyskNettoAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, ZnormalizowanyZysk, OdliczeniaAmortyzacyjne, StawkaPodatkowa)
SELECT
    Data,
    Nazwa,
    [Przychody ogó³em] AS PrzychodyOgolem,
    [Zysk przed opodatkowaniem] AS ZyskPrzedOpodatkowaniem,
    [Zysk netto dla akcjonariuszy zwyk³ych] AS ZyskNettoAkcjonariuszy,
    [Zysk na akcjê podstawow¹] AS ZyskNaAkcjePodstawowe,
    [Zysk na akcjê rozrzedzon¹] AS ZyskNaAkcjeRozrzedzone,
    [Znormalizowany zysk] AS ZnormalizowanyZysk,
    [Zgodne odliczenia amortyzacyjne] AS OdliczeniaAmortyzacyjne,
    [Stawka podatkowa dla obliczeñ] AS StawkaPodatkowa
FROM SANPL_Finanse;



