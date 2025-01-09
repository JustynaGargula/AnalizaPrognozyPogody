#!/bin/bash

# domyślne parametry
city="Kraków"
days=3
file_format="json"
latitude=50.0614
longitude=19.9366
not_silent="true"
multiple_cities="false"
city_list=()

function get_city_coordinates(){
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

function get_and_save_weather_data() {
    # walidacja formatu pliku
    if [[ ! $file_format =~ ^(json|csv|xlsx)$ ]]; then
        echo "Podano nieobsługiwany format pliku ($file_format). Zostanie zapisany plik w formacie json."
        file_format="json"
    fi

    # Pobranie danych pogodowych
    url="https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto&forecast_days=$days&format=$file_format"
    weather_data=$(curl -s -w "%{http_code}" $url)
    http_code="${weather_data: -3}"
    if [ $http_code -ne 200 ]; then
        echo "Nie można pobrać danych pogodowych. Sprawdź swoje połączenie z internetem."
        exit
    fi
    weather_data=${weather_data:0:-3}

    # zapisanie danych do pliku
    file_name="outputData/pogoda$city.$file_format"
    touch $file_name
    if [ $? != 0 ]; then
        echo "Brak praw do utworzenia pliku. Dane pogodowe zostaną zamiast tego wyświetlone."
        echo $weather_data
    else
        echo $weather_data > $file_name
    fi
}

function print_daily_weather() {
    times=($(echo $weather_data | jq -r ".daily.time[]"))
    temps_max=($(echo $weather_data | jq -r ".daily.temperature_2m_max[]"))
    temps_min=($(echo $weather_data | jq -r ".daily.temperature_2m_min[]"))
    #weather_codes=($(echo $weather_data | jq -r ".daily.weather_code[]"))     # Czy chcę to obsługiwać? Jeśli nie to usunąć
    echo "Dane pogodowe dla miasta $city"
    for ((i=0; i<$days; i++)); do
        echo "Dnia ${times[$i]} maksymalna temperatura wyniesie ${temps_max[$i]} °C, a minimalna ${temps_min[$i]} °C."
    done
}

# początek wykonywanego kodu
args=$(getopt -o ":c:hf:d:sm:a" --long "city,help,file,lat,latitude,long,longitude,days,silent,multiple_cities,all_cities" -- "$@")
if [ $? -ne 0 ]; then
    echo "Błąd: nieprawidłowe argumenty. Uruchom opcję --help po więcej informacji."
    exit 1
fi
eval set -- "$args"

while true; do
    # Wczytanie parametrów
    case "$1" in
        --help|-h)
            glow help1.md 2>/dev/null || cat help1.txt
            exit 0 ;;
        -c|--city)
            city=$2
            shift ;;
        -f|--file)
            file_format=$2
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
            not_silent="false" ;;
        -m|--multiple_cities)
            multiple_cities="true"
            city_list=$2
            shift ;;
        -a|--all_cities)
            multiple_cities="true"
            city_list="Kraków Warszawa Rzeszów Paryż Madryt Oslo Rzym Londyn"
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

if [ $multiple_cities == "true" ]; then
    for current_city in $city_list; do
        city=$current_city
        get_city_coordinates $city # odczytanie współrzędnych dla wybranych miast (latitude-szerokość geograficzna, longitude-długość geograficzna)
        get_and_save_weather_data
        if [ $not_silent == "true" ]; then
            print_daily_weather # wypisanie skrótu informacji (raportu pogodowego), jeśli nie podano parametru silent
        fi
    done
    # dorobic pobieranie danych dla wielu miast
else
    get_city_coordinates $city # odczytanie współrzędnych dla wybranych miast (latitude-szerokość geograficzna, longitude-długość geograficzna)
    get_and_save_weather_data
    if [ $not_silent == "true" ]; then
        print_daily_weather # wypisanie skrótu informacji (raportu pogodowego), jeśli nie podano parametru silent
    fi
fi
