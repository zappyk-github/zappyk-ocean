#!/bin/env perl

use strict;
use warnings;

my $SPLIT = ':';
my @FREAD = (1, 10, 11, 12);  
my %CHANNELS;

my $dir = $ARGV[0] || die("$0: specifica la directory con i files da unire.\n");

opendir(my $dh, $dir) || die("$0: apertura directory '$dir' non riuscita.\n");
my @files = grep { ! /^\./ && -f "$dir/$_" } readdir($dh);
closedir($dh);

foreach my $name (@files) {
    my $file = "$dir/$name";
    my $area = "";
       $area = "$1 | " if ($name =~ m/.*-(\w*).conf$/);

    open(my $fh, $file) || die("$0: lettura file '$file' non riuscita.\n");
    my @lines = <$fh>;
    close($fh);

    foreach my $line (@lines) {
        chomp($line); $line = $area.$line;
        my @rows = split(/$SPLIT/, $line);

        my @keys = ();
        foreach my $field (@FREAD) { push(@keys, $rows[$field]) }
        my $key = join($SPLIT, @keys);

        $CHANNELS{$key}{NAME} = $rows[0];
        $CHANNELS{$key}{LINE} = $line;
    }
}

foreach my $channel (sort{ $CHANNELS{$a}{NAME} cmp $CHANNELS{$b}{NAME} } keys %CHANNELS) {
    printf("%s\n", $CHANNELS{$channel}{LINE});
}

exit;
