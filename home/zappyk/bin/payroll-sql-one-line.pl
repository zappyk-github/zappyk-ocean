#!/bin/env perl

use strict;
use warnings;

my $string = $ARGV[0] || '_xxx';
my $regexp = $ARGV[1] || '_xxx';
my $onerow = $ARGV[2] || 0;
  #$onerow = 1;

my $rowend = ($onerow)?' ':"\n";

#CZ# while (my $line = <STDIN>) { _print(_normalize($line)); }

my @lines = <STDIN>;
my $lines_string = join('', @lines);
###$lines_string =~ s/\/\*(.*)\*\///gs;                                      # ...is my solution! :-|
###$lines_string =~ s/((?:\/\*(?:[^*]|(?:\*+[^*\/]))*\*+\/)|(?:\/\/.*))//gs; # ...solution on: (1) https://blog.ostermiller.org/finding-comments-in-source-code-using-regular-expressions/
   $lines_string =~ s/\/\*(?:.|[\r\n])*?\*\///gs;                            # ...solution on: (2)   "
my @lines_array  = split(/\n/, $lines_string, -1);
foreach my $line (@lines_array) { _print(_normalize($line)); }

exit;

################################################################################
sub _regex {
    my ($string, $regex) = @_;
    $_ = $string; eval($regex); $string = $_;
    return($string);
}

################################################################################
sub _normalize {
    my $line = shift;
       $line =~ s/^\s+// if ($onerow);
#CZ#   $line =~ s/$string/$regexp/g if (defined($string) && defined($regexp));
    #---------------------------------------------------------------------------
    for(my $i=0; $i<scalar(@ARGV); $i++) {
        $string = $ARGV[$i++];
        $regexp = $ARGV[$i];
#CZ#    $line =~ s/$string/$regexp/g if (defined($string) && defined($regexp));
        $line = _regex($line, "s/$string/$regexp/g") if (defined($string) && defined($regexp));
    }
    #---------------------------------------------------------------------------
    chomp($line);
    return($line);
}

################################################################################
sub _print {
    my $line = shift;
       $line = _query_ok($line);
    print($line.$rowend) if (_print_ok($line));
}

################################################################################
sub _query_ok {
    my $line = shift;
       $line =~ s/\-\-.*$//;
    return($line);
}

################################################################################
sub _print_ok {
    my $line = shift;
#CZ#return($line !~ m/^\-\-/);
#CZ#return(0) if ($line =~ m/^$/);
    return(0) if ($line =~ m/^\s*$/);
    return(1);
}
