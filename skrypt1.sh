#!/bin/bash

fileType="json" #domyślnie

# Wczytanie parametrów
args=$(getopt -o ":c:hf:" --long "city,help,file" -- "$@")
if [ $? -ne 0 ]; then
    echo "Błąd: nieprawidłowe argumenty. Uruchom opcję --help po więcej informacji."
    exit 1
fi
eval set -- "$args"

while true; do
    case "$1" in
        --help|-h)
            cat help1.txt
            exit 0 ;;
        -c|--city)
            city=$2
            shift ;;
        -f|--file)
            fileType=$2
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

# Pobranie danych pogodowych
curl "https://api.open-meteo.com/v1/forecast?latitude=50.0614&longitude=19.9366&hourly=temperature_2m&forecast_days=3"
# &format=csv <--dane w formacie csv, jest tez xlsx, a domyślny to json
