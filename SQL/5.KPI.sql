-- Teraz gdy mam ju� wszystkie potrzebne dane zaimportowane po poprzednim oczyszczeniu do mojej bazy danych mog� obliczy� najwa�niejsze KPI, kt�re pomog� w ocenie kondycji finansowej i operacyjnej sp�ek



-- Tworz� tabel�, kt�ra przechowuje warto�ci dla wcze�niej wspomnianych KPI

CREATE TABLE KPI (
    Data DATE,
    Nazwa NVARCHAR(255),
    RentownoscKapitaluWlasnego DECIMAL(18, 4),
    WskaznikZadluzeniaNetto DECIMAL(18, 4),
    WolnyPrzeplywPieniezny DECIMAL(18, 2),
    ZyskNaAkcjeRozrzedzone DECIMAL(18, 2)
);



-- Obliczam rentowno�� kapita�u w�asnego i wska�nik zad�u�enia netto na podstawie dost�pnych danych finansowych
-- Pobieram tak�e wolny przep�yw pieni�ny i zysk na akcj� rozrzedzon� bezpo�rednio z tabel finansowych
-- U�ywam ��czenia typu inner join, aby pobra� dane z obu tabel
-- Gotowe dane za��czam do tabeli za pomoc� polecenia insert into

INSERT INTO KPI (Data, Nazwa, RentownoscKapitaluWlasnego, WskaznikZadluzeniaNetto, WolnyPrzeplywPieniezny, ZyskNaAkcjeRozrzedzone)
SELECT
    df.DataRaportu,
    df.Nazwa,
    CASE WHEN wf.Kapita�W�asny != 0 THEN df.ZyskNettoDlaAkcjonariuszy / wf.Kapita�W�asny ELSE NULL END AS RentownoscKapitaluWlasnego,
    CASE WHEN wf.Kapita�W�asny != 0 THEN (wf.SumaD�ugu - wf.StanGot�wki) / wf.Kapita�W�asny ELSE NULL END AS WskaznikZadluzeniaNetto,
    wf.WolnyPrzep�ywPieni�ny,
    df.ZyskNaAkcjeRozrzedzone
FROM
    Dane_Finansowe df
JOIN
    Wskazniki_Finansowe wf ON df.Nazwa = wf.Nazwa AND df.DataRaportu = wf.Data
WHERE
    df.Nazwa IN ('PGE', 'JSW', 'LPP', 'ALLEGRO', 'ORANGEPL', 'CYFRPLSAT', 'KETY', 'KRUK', 'CDPROJECT', 'PKNORLEN', 'KGHM', 'DINOPL', 'BUDIMEX', 'PEPCO');



-- Obliczam rentowno�� kapita�u w�asnego i wska�nik zad�u�enia netto na podstawie dost�pnych danych finansowych bank�w
-- Pobieram tak�e wolny przep�yw pieni�ny i zysk na akcj� rozrzedzon� bezpo�rednio z tabel finansowych
-- U�ywam ��czenia typu inner join, aby pobra� dane z obu tabel
-- Gotowe dane za��czam do tabeli za pomoc� polecenia insert into

INSERT INTO KPI (Data, Nazwa, RentownoscKapitaluWlasnego, WskaznikZadluzeniaNetto, WolnyPrzeplywPieniezny, ZyskNaAkcjeRozrzedzone)
SELECT
    dfb.DataRaportu,
    dfb.Nazwa,
    CASE WHEN wfb.Kapita�W�asny != 0 THEN dfb.ZyskNettoAkcjonariuszy / wfb.Kapita�W�asny ELSE NULL END AS RentownoscKapitaluWlasnego,
    CASE WHEN wfb.Kapita�W�asny != 0 THEN (wfb.SumaD�ugu - wfb.StanGot�wki) / wfb.Kapita�W�asny ELSE NULL END AS WskaznikZadluzeniaNetto,
    wfb.WolnyPrzep�ywPieni�ny,
    dfb.ZyskNaAkcjeRozrzedzone
FROM
    Dane_Finansowe_Banki dfb
JOIN
    Wskazniki_Finansowe_Banki wfb ON dfb.Nazwa = wfb.Nazwa AND dfb.DataRaportu = wfb.Data
WHERE
    dfb.Nazwa IN ('MBANK', 'PZU', 'PKOBP', 'SANPL', 'PEKAO', 'ALIOR');



