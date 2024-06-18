-- Teraz gdy mam ju¿ wszystkie potrzebne dane zaimportowane po poprzednim oczyszczeniu do mojej bazy danych mogê obliczyæ najwa¿niejsze KPI, które pomog¹ w ocenie kondycji finansowej i operacyjnej spó³ek



-- Tworzê tabelê, która przechowuje wartoœci dla wczeœniej wspomnianych KPI

CREATE TABLE KPI (
    Data DATE,
    Nazwa NVARCHAR(255),
    RentownoscKapitaluWlasnego DECIMAL(18, 4),
    WskaznikZadluzeniaNetto DECIMAL(18, 4),
    WolnyPrzeplywPieniezny DECIMAL(18, 2),
    ZyskNaAkcjeRozrzedzone DECIMAL(18, 2)
);



-- Obliczam rentownoœæ kapita³u w³asnego i wskaŸnik zad³u¿enia netto na podstawie dostêpnych danych finansowych
-- Pobieram tak¿e wolny przep³yw pieniê¿ny i zysk na akcjê rozrzedzon¹ bezpoœrednio z tabel finansowych
-- U¿ywam ³¹czenia typu inner join, aby pobraæ dane z obu tabel
-- Gotowe dane za³¹czam do tabeli za pomoc¹ polecenia insert into

INSERT INTO KPI (Data, Nazwa, RentownoscKapitaluWlasnego, WskaznikZadluzeniaNetto, WolnyPrzeplywPieniezny, ZyskNaAkcjeRozrzedzone)
SELECT
    df.DataRaportu,
    df.Nazwa,
    CASE WHEN wf.Kapita³W³asny != 0 THEN df.ZyskNettoDlaAkcjonariuszy / wf.Kapita³W³asny ELSE NULL END AS RentownoscKapitaluWlasnego,
    CASE WHEN wf.Kapita³W³asny != 0 THEN (wf.SumaD³ugu - wf.StanGotówki) / wf.Kapita³W³asny ELSE NULL END AS WskaznikZadluzeniaNetto,
    wf.WolnyPrzep³ywPieniê¿ny,
    df.ZyskNaAkcjeRozrzedzone
FROM
    Dane_Finansowe df
JOIN
    Wskazniki_Finansowe wf ON df.Nazwa = wf.Nazwa AND df.DataRaportu = wf.Data
WHERE
    df.Nazwa IN ('PGE', 'JSW', 'LPP', 'ALLEGRO', 'ORANGEPL', 'CYFRPLSAT', 'KETY', 'KRUK', 'CDPROJECT', 'PKNORLEN', 'KGHM', 'DINOPL', 'BUDIMEX', 'PEPCO');



-- Obliczam rentownoœæ kapita³u w³asnego i wskaŸnik zad³u¿enia netto na podstawie dostêpnych danych finansowych banków
-- Pobieram tak¿e wolny przep³yw pieniê¿ny i zysk na akcjê rozrzedzon¹ bezpoœrednio z tabel finansowych
-- U¿ywam ³¹czenia typu inner join, aby pobraæ dane z obu tabel
-- Gotowe dane za³¹czam do tabeli za pomoc¹ polecenia insert into

INSERT INTO KPI (Data, Nazwa, RentownoscKapitaluWlasnego, WskaznikZadluzeniaNetto, WolnyPrzeplywPieniezny, ZyskNaAkcjeRozrzedzone)
SELECT
    dfb.DataRaportu,
    dfb.Nazwa,
    CASE WHEN wfb.Kapita³W³asny != 0 THEN dfb.ZyskNettoAkcjonariuszy / wfb.Kapita³W³asny ELSE NULL END AS RentownoscKapitaluWlasnego,
    CASE WHEN wfb.Kapita³W³asny != 0 THEN (wfb.SumaD³ugu - wfb.StanGotówki) / wfb.Kapita³W³asny ELSE NULL END AS WskaznikZadluzeniaNetto,
    wfb.WolnyPrzep³ywPieniê¿ny,
    dfb.ZyskNaAkcjeRozrzedzone
FROM
    Dane_Finansowe_Banki dfb
JOIN
    Wskazniki_Finansowe_Banki wfb ON dfb.Nazwa = wfb.Nazwa AND dfb.DataRaportu = wfb.Data
WHERE
    dfb.Nazwa IN ('MBANK', 'PZU', 'PKOBP', 'SANPL', 'PEKAO', 'ALIOR');



