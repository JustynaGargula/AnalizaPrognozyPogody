#!/usr/bin/perl
use strict;
use warnings;

# Wymagane narzędzia: 

foreach my $arg (@ARGV){
    if ($arg eq '-h' || $arg eq '--help') {
        open my $help, "<", "help2.txt" or die "Nie można otworzyć pliku: $!";
        print do { local $/; <$help> }, "\n";
        close $help;
    } else {
        print "Nieznany argument: $arg\n";
    }
}