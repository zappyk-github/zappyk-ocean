#!/bin/env perl
$|=1;

my @keys = @ARGV;

use strict;
use warnings;

while (my $row = <STDIN>) {
    print($row) if ! _isFind($row); 
}

exit;

################################################################################
sub _isFind {
    my $row = shift;
    my $find = 0;
    foreach my $key (@keys) {
        $find = 1 if ($row =~ m/$key/i);
    }
    return($find);
}
