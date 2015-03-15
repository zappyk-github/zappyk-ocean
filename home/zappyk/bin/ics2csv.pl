#!/bin/env perl

use strict;
use warnings;

use File::Basename;

my $file_ics = $ARGV[0] || die("Specifica il file .CSV da convertire in .ICS\n");
my $file_csv = join('/', dirname($file_ics), basename($file_ics, ('.ics', '.ICS')).'.csv');
   $file_csv = $ARGV[1] || $file_csv;

my @data_csv = ('SUMMARY', 'DTSTART', 'DTEND', 'DESCRIPTION');
my %data_ics;

open(FH_ICS, '<', $file_ics) || die("Non posso leggere il file '$file_ics'\n");
open(FH_CSV, '>', $file_csv) || die("Non posso scrivere il file '$file_csv'\n");

my $block = 0;
my $event = 0;
while (my $line = <FH_ICS>) {
    chomp($line);
    chop($line);

    $block = 1 if (($block == 0) && ($line =~ m/BEGIN:VCALENDAR/));
    $block = 2 if (($block == 1) && ($line =~ m/BEGIN:VEVENT/));
    $event++   if (($block == 2) && ($line =~ m/BEGIN:VEVENT/));
    $block = 1 if (($block == 2) && ($line =~ m/BEGIN:END/));
    $block = 0 if (($block == 1) && ($line =~ m/END:VCALENDAR/));

    if ($block == 2) {
        my $ksub;
        my @vals = split(/:/, $line);
        my $kkey = shift(@vals);
          ($kkey
          ,$ksub)= split(/;/, $kkey);
        my $vval = join(':', @vals);
           $vval = join(':', $ksub, $vval) if (defined($ksub));

        $data_ics{$event}{$kkey} = $vval;

        printf("[%3s] %15s = (%s)\n", $event, $kkey, $vval);
    }
}

my $first = 1;
foreach $event (sort keys %data_ics) {
    _print_csv(@data_csv) if ($first);
    my @values = map{ _print_csv_date($_, $data_ics{$event}{$_}) } @data_csv;
    _print_csv(@values);
    $first = 0;
}

close(FH_ICS);
close(FH_CSV);

exit;

################################################################################
sub _print_csv {
    my @fields = @_;
    print(FH_CSV join(',', @fields), "\n");
}

################################################################################
sub _print_csv_date {
    my $field = shift; $field = uc($field);
    my $value = shift;

    if (($field eq 'DTSTART') || ($field eq 'DTEND')) {
        $value = join(' ', $1, join(':', substr($2, 0, 2), substr($2, 2, 2))) if ($value =~ m/(\d{8})T(\d{4})\d\d\w/);
        $value = join(' ', $1, join(':',             '--',             '--')) if ($value =~ m/VALUE=DATE:(\d{8})/);
    }

    return($value);
}
