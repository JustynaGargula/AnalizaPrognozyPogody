#!/bin/bash

# domyślne parametry
city="Kraków"
days=3
fileFormat="json"
latitude=50.0614
longitude=19.9366
notSilent="true"
multipleCities="false"
cityList=()

get_city_coordinates(){
    case "$1" in
        Kraków)
            latitude=50.0614
            longitude=19.9366 ;;
        Warszawa)
            latitude=52.2298
            longitude=21.0118 ;;
        Rzeszów)
            latitude=50.0413
            longitude=21.999 ;;
        Paryż)
            latitude=48.8534
            longitude=2.3488 ;;
        Madryt)
            latitude=40.4165
            longitude=-3.7026 ;;
        Oslo)
            latitude=59.9127
            longitude=10.7461 ;;
        Rzym)
            latitude=41.8919
            longitude=12.5113 ;;
        Londyn)
            latitude=51.5085
            longitude=-0.1257 ;;
        *)
            city=""
            echo "Podano nieznane miasto ($city). Zostają pobrane dane dla domyślnych wartości lub innych współrzędnych geograficznych, jeśli je podano." ;;
    esac
}

get_and_save_weather_data() {
    # walidacja formatu pliku
    if [[ ! $fileFormat =~ ^(json|csv|xlsx)$ ]]; then
        echo "Podano nieobsługiwany format pliku ($fileFormat). Zostanie zapisany plik w formacie json."
        fileFormat="json"
    fi

    # Pobranie danych pogodowych
    url="https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto&forecast_days=$days&format=$fileFormat"
    weatherData=$(curl -s -w "%{http_code}" $url)
    http_code="${weatherData: -3}"
    if [ $http_code -ne 200 ]; then
        echo "Nie można pobrać danych pogodowych. Sprawdź swoje połączenie z internetem."
        exit
    fi
    weatherData=${weatherData:0:-3}

    # zapisanie danych do pliku
    fileName="outputData/pogoda$city.$fileFormat"
    touch $fileName
    if [ $? != 0 ]; then
        echo "Brak praw do utworzenia pliku. Dane pogodowe zostaną zamiast tego wyświetlone."
        echo $weatherData
    else
        echo $weatherData > $fileName
    fi
}

print_daily_weather() {
    times=($(echo $weatherData | jq -r ".daily.time[]"))
    tempsMax=($(echo $weatherData | jq -r ".daily.temperature_2m_max[]"))
    tempsMin=($(echo $weatherData | jq -r ".daily.temperature_2m_min[]"))
    #weatherCodes=($(echo $weatherData | jq -r ".daily.weather_code[]"))     # Czy chcę to obsługiwać? Jeśli nie to usunąć
    echo "Dane pogodowe dla miasta $city"
    for ((i=0; i<$days; i++)); do
        echo "Dnia ${times[$i]} maksymalna temperatura wyniesie ${tempsMax[$i]} °C, a minimalna ${tempsMin[$i]} °C."
    done
}

# początek wykonywanego kodu
args=$(getopt -o ":c:hf:d:sm:" --long "city,help,file,lat,latitude,long,longitude,days,silent,multipleCities" -- "$@")
if [ $? -ne 0 ]; then
    echo "Błąd: nieprawidłowe argumenty. Uruchom opcję --help po więcej informacji."
    exit 1
fi
eval set -- "$args"

while true; do
    # Wczytanie parametrów
    case "$1" in
        --help|-h)
            cat help1.txt
            exit 0 ;;
        -c|--city)
            city=$2
            shift ;;
        -f|--file)
            fileFormat=$2
            shift ;;
        --lat|--latitude)
            latitude=$2
            shift ;;
        --long|--longitude)
            longitude=$2
            shift ;;
        -d|--days)
            days=$2
            shift ;;
        -s|--silent)
            notSilent="false" ;;
        -m|--multipleCities)
            multipleCities="true"
            cityList=$2
            shift ;;
        --)
            shift
            break ;;
        *) 
            echo "Nieprawidłowy parametr $1"
            exit 1 ;;
    esac
    shift
done

if [ $multipleCities == "true" ]; then
    echo ""
    # dorobic pobieranie danych dla wielu miast
else
    get_city_coordinates $city # odczytanie współrzędnych dla wybranych miast (latitude-szerokość geograficzna, longitude-długość geograficzna)
    get_and_save_weather_data
    if [ $notSilent == "true" ]; then
        print_daily_weather # wypisanie skrótu informacji (raportu pogodowego), jeśli nie podano parametru silent
    fi
fi
