-- Kolejnym krokiem jest �ci�gni�cie danych finansowych z Yahoo Finance -> Financials -> Income Statement do pliku excel w formacie .xlsx (dla ka�dej sp�ki z osobna)
-- Zamieniam przecinki na kropki, aby format by� odpowiedni dla sql management studio
-- Za pomoc� "SQL Server 2019 Import and Export Data (64-bit)" importuj� dane z excela z danymi finansowymi do mojej bazy danych sql 


-- Nast�pnie tworz� tabel�, kt�ra przechowuje wszystkie dane finansowe dla ka�dej ze sp�ek 

create table Dane_Finansowe (
	Nazwa varchar(50),
    DataRaportu DATE,
    PrzychodyOgolem DECIMAL(18, 2),
    KosztyPrzychodu DECIMAL(18, 2),
    ZyskBrutto DECIMAL(18, 2),
	KosztyOperacyjne DECIMAL(18,2),
    ZyskOperacyjny DECIMAL(18, 2),
    ZyskNettoDlaAkcjonariuszy DECIMAL(18, 2),
    ZyskNaAkcjePodstawowe DECIMAL(18, 2),
    ZyskNaAkcjeRozrzedzone DECIMAL(18, 2),
    SredniaIloscAkcjiRozrzedzonych DECIMAL(18, 2),
    DochodyZOdsetek DECIMAL(18, 2),
    KosztyOdsetek DECIMAL(18, 2),
    ZyskZOpodatkowaniemIOdsetkami DECIMAL(18, 2),
    ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja DECIMAL(18, 2)
);



-- Nast�pnie u�ywam polecenia insert into, aby doda� wszystkie wcze�niej zaimportowane dane finansowe sp�ek do mojej tabeli wsp�lnej

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM ALLEGRO_Finanse;

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM BUDIMEX_Finanse;

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM CD_PROJECT_Finanse;

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM CYFRPLSAT_Finanse;

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM DINO_Finanse;


INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM JSW_Finanse;

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM KETY_Finanse;

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM KGHM_Finanse;

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM KRUK_Finanse;

EXEC sp_rename 'Arkusz1$', 'PKNORLEN_Finanse';

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM LPP_Finanse;

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM ORANGEPL_Finanse;

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM PEPCO_Finanse;

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM PGE_Finanse;

INSERT INTO Dane_Finansowe (DataRaportu, Nazwa, PrzychodyOgolem, KosztyPrzychodu, ZyskBrutto, KosztyOperacyjne, ZyskOperacyjny, 
ZyskNettoDlaAkcjonariuszy, ZyskNaAkcjePodstawowe, ZyskNaAkcjeRozrzedzone, SredniaIloscAkcjiRozrzedzonych, DochodyZOdsetek, KosztyOdsetek,
ZyskZOpodatkowaniemIOdsetkami, ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja)
SELECT 
    CONVERT(DATE, Data, 101) AS DataRaportu,
	Nazwa,
	[Przychody og�em] as PrzychodyOgolem,
	[Koszty operacyjne] as KosztyPrzychodu,
	[Zysk brutto] as ZyskBrutto,
	[Koszty operacyjne1] as KosztyOperacyjne,
	[Zysk operacyjny] as ZyskOperacyjny,
	[Zysk netto dla akcjonariuszy] as ZyskNettoDlaAkcjonariuszy,
	[Zysk na akcj� podstawow�] as ZyskNaAkcjePodstawowe,
	[Zysk na akcj� rozrzedzon�] as ZyskNaAkcjeRozrzedzone,
	[�rednia ilo�� akcji rozrzedzonych] as SredniaIloscAkcjiRozrzedzonych,
	[Dochody z odsetek] as DochodyZOdsetek,
	[Koszty odsetek] as KosztyOdsetek,
	[Zysk z opodatkowaniem i odsetkami] as ZyskZOpodatkowaniemIOdsetkami,
	[Zysk przez odpodatkowaniem odsetkami i amortyzacj�] as ZyskPrzedOpodatkowaniemOdsetkamiIAmortyzacja
FROM PKNORLEN_Finanse;




