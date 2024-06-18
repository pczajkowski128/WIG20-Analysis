-- Tworz� tabel� g��wn�, kt�ra b�dzie przechowywa� dane o cenach dla sp�ek z indeksu WIG20 

create table companies_quotes (
	Name varchar(100),
	Data_Date Date,
	Open_Price decimal(10, 4),
	Highest_Price decimal(10, 4),
	Lowest_Price decimal(10, 4),
	Close_Price decimal(10, 4),
	Adj_Close_Price decimal(10, 4),
	Volume bigint);

-- Wszystkie dane pozyskuj� ze strony Yahoo Finance -> Historical Data 
-- Dane pobierane s� w formacie CSV co jest nieodpowiednie dla sql management studio dlatego wprowadzam je do mojej bazy danych za pomoc� pythona w kt�rym zamieniam warto�ci na listy

