#!/bin/bash

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
