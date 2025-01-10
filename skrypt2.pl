#!/usr/bin/perl
use strict;
use warnings;
use JSON;

# Wymagane narzędzia: JSON

my $multiple="false";
my $file_format="json";
my @files;
my $city_file;
my $generate_forecast="false";
my @cities_to_generate;

sub get_city_from_coordinates {
    my ($latitude, $longitude) = @_;
    my $city;

if ($latitude == 50.064266 && $longitude == 19.923676) {
    $city = "Kraków";
} elsif ($latitude == 52.23009 && $longitude == 21.017075) {
    $city = "Warszawa";
} elsif ($latitude == 50.03909 && $longitude == 22.010834) {
    $city = "Rzeszów";
} elsif ($latitude == 48.86 && $longitude == 2.3399997) {
    $city = "Paryż";
} elsif ($latitude == 40.4375 && $longitude == -3.6875) {
    $city = "Madryt";
} elsif ($latitude == 59.915257 && $longitude == 10.742905) {
    $city = "Oslo";
} elsif ($latitude == 41.875 && $longitude == 12.5) {
    $city = "Rzym";
} elsif ($latitude == 51.5 && $longitude == -0.120000124) {
    $city = "Londyn";
} else {
    $city = "Nieznane miasto";
    #print "Podano nieznane współrzędne ($latitude, $longitude). Proszę sprawdzić wartości.\n";
}

    return $city;
}

# Czytanie argumentów początkowych
for (my $i=0; $i<@ARGV; $i++){
    if ($ARGV[$i] eq '-h' || $ARGV[$i] eq '--help') {
        open my $help, "<", "help2.txt" or die "Nie można otworzyć pliku: $!";
            print do { local $/; <$help> }, "\n";
        close $help;
    } elsif ($ARGV[$i] eq '-m' || $ARGV[$i] eq '--multiple_cities') {
        $multiple="true";
        @files=split / /, $ARGV[$i+1]; 
        $i++;
    } elsif ($ARGV[$i] eq '-c' || $ARGV[$i] eq '--city_file') {
        $city_file=$ARGV[$i+1];
        $i++;
    } elsif ($ARGV[$i] eq '-f' || $ARGV[$i] eq '--file_format') {
        $file_format=$ARGV[$i+1];
        $i++;
    } elsif ($ARGV[$i] eq '-g' || $ARGV[$i] eq '--generate_forecast') {
        $generate_forecast="true";
        @cities_to_generate=$ARGV[$i+1];
        $i++;
    } else {
        print "Nieznany argument: $ARGV[$i]\n";
    }
}

if($generate_forecast eq "true"){
    my @cities=split / /, @cities_to_generate;
    foreach my $city (@cities){
        system("./skrypt1.sh -c $city -s");
    }
}

# odczytuję wybrane dane z plików i je analizuję
if($multiple eq "true" && $file_format eq "json"){
    my @max_temperature=(-100, "", ""); # przechowa temperaturę, miasto i datę
    my @min_temperature=(100, "", ""); # przechowa temperaturę, miasto i datę
    my %weather_codes_counts;
    # dla każdego pliku z listy: odczytać dane z jsona, porównać z danymi w zmiennych
    foreach my $file_name (@files){
        open my $file, "<", "outputData/$file_name" or next;
            my $json_text = do { local $/; <$file> };
        close $file;
        my $data = decode_json($json_text);
        my @temperatures=@ {$data->{daily}->{temperature_2m_max}};
        for (my $i=0; $i<@temperatures; $i++){
            my $temperature = $temperatures[$i];
            if($temperature > $max_temperature[0]){
                my $latitude = $data->{latitude};
                my $longitude = $data->{longitude};
                my $day = @{$data->{daily}->{time}}[$i];
                @max_temperature  = ($temperature, get_city_from_coordinates($latitude, $longitude), $day);
            }
            if ($temperature < $min_temperature[0]) {
                my $latitude = $data->{latitude};
                my $longitude = $data->{longitude};
                my $day = @{$data->{daily}->{time}}[$i];
                @min_temperature  = ($temperature, get_city_from_coordinates($latitude, $longitude), $day);
            }
            #TODO odczytać weather_code i doliczyć do tablicy
        }
    }
    if(defined $max_temperature[2] && $max_temperature[2] ne ""){
        print "Porównano dane. Z ich analizy wynika, że:\n";
        print "najwyższa temperatura będzie " . $max_temperature[2] . " w " . $max_temperature[1] . " i wyniesie ona " . $max_temperature[0] . "°C,\n";
        print "najniższa temperatura będzie " . $min_temperature[2] . " w " . $min_temperature[1] . " i wyniesie ona " . $min_temperature[0] . "°C,\n";
    } else {
        print "Nie można było odczytać plików z listy\n"
    }

    #TODO wyświetlić najczęstszy kod pogodowy i jego interpretację
} else {
    open my $file, "<", "outputData/$city_file" or print "Nie można odczytać pliku; $city_file.\n";
        my $json_text = do { local $/; <$file> };
    close $file;
    my $data = decode_json($json_text);
    my @max_temperature=(-100, ""); # temperatura, data
    my @min_temperature=(100, "");
    my @temperatures = @{$data->{hourly}->{temperature_2m}};
    for (my $i=0; $i<@temperatures; $i++){
        my $temperature = $temperatures[$i];
        my $date = @{$data->{hourly}->{time}}[$i];
        if($temperature > $max_temperature[0]){
            @max_temperature = ($temperature, $date);
        }
        if($temperature < $min_temperature[0]){
            @min_temperature = ($temperature, $date);
        }
    }
    if(defined $max_temperature[1] && $max_temperature[1] ne ""){
        print "Porównano dane. Z ich analizy wynika, że:\n";
        my @date_max=split /T/, $max_temperature[1];
        my @date_min=split /T/, $min_temperature[1];
        print "najwyższa temperatura będzie " . $date_max[0] . " o " . $date_max[1] . " i wyniesie ona " . $max_temperature[0] . "°C,\n";
        print "najniższa temperatura będzie " . $date_min[0] . " o " . $date_min[1] . " i wyniesie ona " . $min_temperature[0] . "°C.\n";
    } else {
        print "Nie można było odczytać plików z listy\n"
    }
}