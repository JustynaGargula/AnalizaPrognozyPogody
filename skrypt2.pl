#!/usr/bin/perl
use strict;
use warnings;

# Wymagane narzędzia: 
my $multiple="false";
my $file_format="json";
my @files;

# Czytanie argumentów początkowych
for (my $i=0; $i<@ARGV; $i++){
    if ($ARGV[$i] eq '-h' || $ARGV[$i] eq '--help') {
        open my $help, "<", "help2.txt" or die "Nie można otworzyć pliku: $!";
        print do { local $/; <$help> }, "\n";
        close $help;
    } elsif ($ARGV[$i] eq '-m' || $ARGV[$i] eq '--multiple_cities') {
        $multiple="true";
        my @files=$ARGV[$i+1]; 
        $i++;
    } elsif ($ARGV[$i] eq '-f' || $ARGV[$i] eq '--file_format') {
        $file_format=$ARGV[$i+1];
        $i++;
    } else {
        print "Nieznany argument: $ARGV[$i]\n";
    }
}

my $max_temperature;
my $min_temperature;
my %weather_codes_counts;
if($multiple eq "true"){
    # dla każdego pliku z listy: odczytać dane z jsona, porównać z danymi w zmiennych
} else {
    #TODO analiza danych dla jednego miasta
}