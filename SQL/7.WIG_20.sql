-- W tym skrypcie przekszta�cam dane historyczne dla cen indeksu WIG20, kt�re zosta�y pobrane z BiznesRadar.pl
-- Oryginalna kolumna Data_Date zawiera�a daty w niepoprawnym formacie dla mojego projektu
-- Celem skryptu jest sformatowanie dat do formatu 'yyyy-MM-dd', aby by�y zgodne z wymaganiami projektu
-- Dodaj� now� kolumn� do tabeli, formatuj� daty, usuwam star� kolumn� i zmieniam nazw� nowej kolumny na oryginaln� nazw�
-- Ten proces zapewnia, �e dane s� w odpowiednim formacie i gotowe do dalszej analizy

ALTER TABLE WIG_20
ADD FormattedData_Date VARCHAR(10);

UPDATE WIG_20
SET FormattedData_Date = FORMAT(Data_Date, 'yyyy-MM-dd');

ALTER TABLE WIG_20
DROP COLUMN Data_Date;

EXEC sp_rename 'WIG_20.FormattedData_Date', 'Data_Date', 'COLUMN';