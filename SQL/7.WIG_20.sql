-- W tym skrypcie przekszta³cam dane historyczne dla cen indeksu WIG20, które zosta³y pobrane z BiznesRadar.pl
-- Oryginalna kolumna Data_Date zawiera³a daty w niepoprawnym formacie dla mojego projektu
-- Celem skryptu jest sformatowanie dat do formatu 'yyyy-MM-dd', aby by³y zgodne z wymaganiami projektu
-- Dodajê now¹ kolumnê do tabeli, formatujê daty, usuwam star¹ kolumnê i zmieniam nazwê nowej kolumny na oryginaln¹ nazwê
-- Ten proces zapewnia, ¿e dane s¹ w odpowiednim formacie i gotowe do dalszej analizy

ALTER TABLE WIG_20
ADD FormattedData_Date VARCHAR(10);

UPDATE WIG_20
SET FormattedData_Date = FORMAT(Data_Date, 'yyyy-MM-dd');

ALTER TABLE WIG_20
DROP COLUMN Data_Date;

EXEC sp_rename 'WIG_20.FormattedData_Date', 'Data_Date', 'COLUMN';