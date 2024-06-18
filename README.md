# Analiza spółek wchodzących w skład indeksu WIG20


## Wstęp
Projekt ten obejmuje kompleksową analizę spółek giełdowych należących do indeksu WIG20.
Celem analizy jest dostarczenie dokładnych i interaktywnych wizualizacji danych finansowych, które mogą być użyteczne dla inwestorów i analityków finansowych.


## Zbieranie danych
Dane do analizy zostały zebrane z różnych źródeł internetowych, takich jak Biznes Radar i Yahoo Finance. Dane te obejmowały ceny akcji, przepływy pieniężne oraz różne wskaźniki finansowe.
Po pobraniu danych, były one przetwarzane w programie Excel, gdzie m.in. zamieniano przecinki na kropki w wartościach liczbowych.


## Baza danych SQL
Dane przetworzone w Excelu były następnie importowane do bazy danych SQL.
Utworzone zostały różne tabele, które przechowywały ceny akcji, dane finansowe oraz linki do logo spółek, co umożliwiło ich późniejsze wykorzystanie w wizualizacjach.
Do obliczeń używane były m.in. tabele tymczasowe, funkcje okienkowe oraz kursory SQL.


### Przykłady tabel SQL:
- **Tabele cen spółek:** Przechowywały historyczne ceny akcji.
- **Tabele danych finansowych:** Zawierały dane takie jak przepływy pieniężne, wskaźniki rentowności, itp.
- **Tabele z logami spółek:** Umożliwiały wizualizację logo spółek w Power BI.


### Obliczenia i analizy SQL:
- **Krzywe kroczące:** Obliczenia wskaźników takich jak EMA, SMA, RSI, MACD, Signal.
- **Obliczenia mediany:** Mediana cen akcji była obliczana w celu lepszego zrozumienia trendów cenowych na przestrzeni lat.
- **Kursory SQL:** Wykorzystane do iteracji rekordów i obliczeń na dużych zestawach danych.


## Power BI
Głównym narzędziem wizualizacji danych był Power BI, gdzie wszystkie dane były przedstawione w formie interaktywnych dashboardów.


### Kluczowe elementy wizualizacji:
- **KPI:** Kluczowe wskaźniki efektywności, takie jak rentowność kapitału, wskaźnik zadłużenia, zysk na akcję.
- **Przepływy pieniężne:** Wizualizacje przepływów pieniężnych w różnych okresach.
- **Krzywe kroczące:** EMA, SMA, RSI, MACD, Signal.
- **Zmiany cen:** Analiza cen akcji na przestrzeni lat.
- **Tooltipy:** Interaktywne opisy pojawiające się po najechaniu kursorem na wykresy.
- **Fragmentatory:** Umożliwiające filtrowanie danych według różnych kryteriów, takich jak zakres dat czy konkretne spółki.


### Funkcje zaawansowane:
- **Formatowanie warunkowe:** Kolory wskazujące na sygnały kupna lub sprzedaży na podstawie analizowanych wskaźników.
- **Interaktywne ikony:** Ikony w lewym górnym rogu umożliwiające nawigację między różnymi dashboardami.


## Podsumowanie
Projekt "Analiza spółek wchodzących w skład indeksu WIG20" jest przykładem zaawansowanej analizy danych finansowych z wykorzystaniem zarówno SQL, jak i narzędzi wizualizacyjnych Power BI.
Dzięki interaktywności i szczegółowości, dostarcza on wartościowych informacji dla inwestorów i analityków, umożliwiając podejmowanie lepszych decyzji inwestycyjnych.


Dzięki połączeniu zaawansowanych technik analizy danych z intuicyjnymi wizualizacjami, projekt ten stanowi solidną podstawę do dalszych badań i analiz finansowych.