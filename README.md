# AnalizaPrognozyPogody
Projekt zaliczeniowy z przedmiotu Pracownia Języków Skryptowych. Składa się z dwóch części napisanych w Bashu i Perlu.

## Wymogi do projektu zaliczeniowego
* Temat projektu dowolny, celem jest prezentacja swoich umiejętności. Temat najlepiej wybrać z własnymi zainteresowaniami - łatwiej się pisze. Temat projektu należy uzgodnić z prowadzącycm ćwiczenia. Projekt musi pokazać umiejętność programowania w powłoce, perlu. Projekt mogą stanowić niezależne mini-projekty, choć nie muszą.
* Terminem przesłania projektu zaliczeniowego jest **10 stycznia 2025 (do północy)**. Terminem rozliczenia projektu jest koniec semestru (28 stycznia 2025).
* Całość jest spakowana jako plik zip i jest wysyłana przez sprawdzarkę do zadania o nazwie "PROJEKT" - oczywiście nie będzie "autoamtycznie" sprawdzane
* Każdy pisze swój projekt sam, oczywiście mile widziana jest dyskusja o projektach, programowaniu, ale koniec końców praca musi być w pełni samodzielna.
* Projekt może być na podstawie jakiegoś zadania z ćwiczeń - wtedy wartość projektu stanowi kod dodany ponad treść zadania
* Program musi wspierać wywołanie z parametrem -h, który wywołuje "help", który drukuje parametry obsługiwane przez program oraz krótki opis działania. Po wydrukowaniu informacji program kończy działanie i zwraca 0.
* Program nie powinien nigdy się wysypywać. Pełna walidacja danych wejściowych jest trudna i ten wymóg podlega negocjacji - która musi nastąpić w ramach uzgadniania tematu projektu. Jeśli program tworzy pliki, należy rozpatrzyć brak możliwości utworzenia pliku, czy brak uprawnień do odczytu.
* Ewentualna konfiguracja nie może odbyać się przez ingerencję w treść skrypu.
* Minimalna długość projektu: **200 linii**. Nie liczą się linie zakomentowane, #include, #define, puste, składające się tylko z klamerek
* Program powinien demonstrować umiejętność stworzenia własnego modułu/biblioteki. W szczególności warto szukać plików z modułem nie tylko w karotekach systemowych i `pwd` ale też w katalogu gdzie znajduje się plik z uruchamianym skryptem.
* Można korzystać z bibliotek zewnętrznych, ale wtedy należy to udokumentować. Co więcej program nie może się sprowadzać do wywołań takiej biblioteki
* Ocenie podlega pomysł i wykonanie. Można/warto dołączyć przykłądowe pliki wejściowe, które pozwolą docenić piękno napisanego programu.

### Mile widziane:
* jakiś porządek w nazwach zmiennych i funkcji. Powinny one coś oznaczać, szczególnie w przypadku zmiennych globalnych (których nie należy nadużywać)
* podział długich funkcji na krótkie
* dokumentacja co robią funkcje (nie jak, ale co) - komentarze w pliku źródłowym wystarczą.

## Pomysł na projekt - opis
Celem projektu jest stworzenie zestawu narzędzi w Bashu i Perlu do pobierania, przetwarzania i analizy danych pogodowych. Projekt użyje zewnętrzne API do pobierania prognoz pogodowych.

Program bashowy pobierze dane pogodowe zgodnie z podanymi parametrami i zapisze je w pliku wybranego formatu, natomiast program w Perlu zwróci raport z wybranymi statystykami tych danych pogodowych.
