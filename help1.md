# Opis programu
Program pobiera dane pogodowe zgodnie z podanymi parametrami i zapisuje je w pliku wybranego formatu w folderze /outputData. 

Dane pogodowe są pobierane przy użyciu witryny [https://open-meteo.com/](https://open-meteo.com/).

Uruchomienie programu bez żadnych parametrów odczyta pogodę dla: miasta Kraków, na 3 dni i zapisze ją w formacie json.
# Wywołanie skryptu
./skrypt1.sh [parametry]
# Obsługiwane parametry:
**-a, --all_cities**
zostanie pobrana pogoda dl awszytskich miast z następującej listy: Kraków, Warszawa, Rzeszów, Paryż, Madryt, Oslo, Rzym, Londyn.
**-c, --city <nazwa_miasta>**
miasto, dla którego ma być pobrana pogoda. Dozwolone są: Kraków, Warszawa, Rzeszów, Paryż, Madryt, Oslo, Rzym, Londyn. Jeśli chcesz pobrać pogodę dla innego miasta podaj jego współrzędne geograficzne opcjami --lat i --lang
**-d, --days <liczba_dni>**
na ile dni ma być pobrana prognoza
**-f, --file <format_pliku>**
typ pliku, w którym mają być zapisane dane. Dozwolone są: json (domyślnie), csv i xlsx.
**-h, --help**
opis programu i dostępnych parametrów
**--lat, --latitude <szerokość>**
szerokość geograficzna, należy podać też długość geograficzną parametrem --long (--lat i --long używane są w przypadku niepodania miasta lub gdy nieznane są współrzędne danego miasta)
**--long, --longitude <długość>**
długość geograficzna, należy podać też szerokość geograficzną parametrem --lat (--lat i --long używane są w przypadku niepodania miasta lub gdy nieznane są współrzędne danego miasta)
**-m, --multiple_cities <lista_miast>**
można podać w cudzysłowie listę miast (ich nazw) oddzielonych spacją. Uwaga: muszą to być miasta z następującej listy: Kraków, Warszawa, Rzeszów, Paryż, Madryt, Oslo, Rzym, Londyn.
**-s, --silent**
jeśli użyto tego parametru, to program nie wyświetli skrótowego raportu pogodowego.

# Przykład wywołania programu
`./skrypt1.sh -c Rzym -d 5` (zostanie pobrana pogoda dla Rzymu na 5 dni)