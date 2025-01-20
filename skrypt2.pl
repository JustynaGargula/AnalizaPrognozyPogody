#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use GD::Graph::lines;
# use utf8;
# binmode STDOUT, ':encoding(UTF-8)';


# Wymagane narzędzia: JSON, GD (może wymagać innych narzędzi do instalacji)

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

sub create_plot {
    my ($json_data, $file_name)=@_;
    my $city;
    if ($file_name =~ /pogoda(.*?)\./) {
        $city = $1;
    } else {
        $city="?";
    }
    my @time = @{$json_data->{hourly}->{time}};
    my @temperatures = @{$json_data->{hourly}->{temperature_2m}};
    my @data = (\@time, \@temperatures);
    for (my $i=0; $i<@time; $i++){
        my @temp_time=split /T/,$time[$i];
        $time[$i]=$temp_time[0] . " o " . $temp_time[1];
    }
    my $start_date=$time[0];
    my $last_date=$time[@time-1];

    my $graph = GD::Graph::lines->new(600, 400);
    $graph->set_title_font('/fonts/arial.ttf', 18);
    $graph->set_legend_font('/fonts/arial.ttf', 12);
    $graph->set( title => "Pogoda $city od $start_date do $last_date",
                y_label => "Temperatura",
                x_label => "Data",
                bgclr => "white",
                transparent => 0,
                x_labels_vertical => 1,
                x_label_skip    => 3,
                fgclr => "gray",
                ) or die $graph->error;

    my $gd = $graph->plot(\@data) or die $graph->error;
    open(IMG, ">outputData/file$city.png") or die $!;
    binmode IMG;
    print IMG $gd->png;
    close IMG;
}
if(@ARGV==0){
    $generate_forecast="true";
    @cities_to_generate="Kraków";
    $city_file="pogodaKraków.json";
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
        @cities_to_generate=split(" ",$ARGV[$i+1]);
        $i++;
    } else {
        print "Nieznany argument: $ARGV[$i]\n";
    }
}

if($generate_forecast eq "true"){
    $multiple="true";
    foreach (my $i=0; $i<@cities_to_generate; $i++){
        my $city=$cities_to_generate[$i];
        system("./skrypt1.sh -c $city -s");
        push @files, "pogoda$city.$file_format";
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
        }
        create_plot($data, $file_name);
    }
    if(defined $max_temperature[2] && $max_temperature[2] ne ""){
        print "Porównano dane. Z ich analizy wynika, że:\n";
        print "najwyższa temperatura będzie " . $max_temperature[2] . " w " . $max_temperature[1] . " i wyniesie ona " . $max_temperature[0] . "°C,\n";
        print "najniższa temperatura będzie " . $min_temperature[2] . " w " . $min_temperature[1] . " i wyniesie ona " . $min_temperature[0] . "°C,\n";
    } else {
        print "Nie można było odczytać plików z listy\n"
    }

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
    create_plot($data, $city_file);
}