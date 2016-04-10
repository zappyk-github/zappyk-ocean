#!/bin/env perl

use strict;
use warnings;

use File::Basename;

my $path_base = $ARGV[0] || die("Specifica il PATH di ricerca...\n");
my $list_file = "find -L \"$path_base\" -type f -print0 | xargs -0 -i bash -c 'basename \"{}\"'";
   $list_file = "find -L \"$path_base\" -type f -print0 | xargs -0 -i bash -c 'echo \"{}\"'";

my $file_skip = '(jpg|png)$';

my $csv_quota = '"';
my $csv_field = ',';

_sort(_list($path_base, $list_file));

exit;

################################################################################
sub _sort {
    my(%data)= @_;
    my $first = 1;
    foreach my $line (sort { $data{$b}{YEAR} cmp $data{$a}{YEAR}
                           ||$data{$a}{NAME} cmp $data{$b}{NAME}
                           ||$data{$a}{PATH} cmp $data{$b}{PATH} } keys %data) {
        printf("%s\n", _writeln('PATH', 'NAME', 'YEAR', 'FILE_PATH', 'FILE_NAME', 'SIZE')) if ($first == 1);
        printf("%s\n", _writeln($data{$line}{PATH}
                               ,$data{$line}{NAME}
                               ,$data{$line}{YEAR}
                               ,$data{$line}{FILE_PATH}
                               ,$data{$line}{FILE_NAME}
                               ,$data{$line}{FILE_SIZE}));
        $first = 0;
    }
}

################################################################################
sub _list {
    my $path = shift;
    my $cmmd = shift;
    my %list;
    my %data;

    foreach my $file (`$cmmd`) {
        chop($file);

        next if ($file =~ m/$file_skip/i);

        my $size = `du "$file" | cut -f1`; chomp($size);
        my $name = basename($file);
           $name = basename(dirname($file)) if ($name =~ m/^(VIDEO_TS|VTS_)/);
           $name = _replace($name);
           $name = _cutExte($name);
       (my $year,
           $name)= _getYear($name);
           $name = _ecalper($name);
           $name = _valText($name);
        my $line = _writeln($path, $name, $year);

        if ($size > ($list{$line}{FILE_SIZE} || 0)) {
            $list{$line}{PATH}      = $path;
            $list{$line}{NAME}      = $name;
            $list{$line}{YEAR}      = $year;
            $list{$line}{FILE_PATH} = dirname($file);
            $list{$line}{FILE_NAME} = basename($file);
            $list{$line}{FILE_SIZE} = $size;
        }
    }

    foreach my $line (keys %list) {
        $data{$line}{PATH}      = $list{$line}{PATH};
        $data{$line}{NAME}      = $list{$line}{NAME};
        $data{$line}{YEAR}      = $list{$line}{YEAR};
        $data{$line}{FILE_PATH} = $list{$line}{FILE_PATH};
        $data{$line}{FILE_NAME} = $list{$line}{FILE_NAME};
        $data{$line}{FILE_SIZE} = $list{$line}{FILE_SIZE};
    }

    return(%data);
}

################################################################################
sub _writeln {
    my @cols = @_;
    my $line = sprintf("$csv_quota%s$csv_quota", join("$csv_quota$csv_field$csv_quota", @cols));
    return($line);
}

################################################################################
sub _getYear {
    my $name = shift;
    my $year = '';
       $year = $1 if ($name =~ s/\s*\((\d\d\d\d)\)//);
    return($year, $name);
}

################################################################################
sub _valText {
    my $string = shift;
       $string = "'$string" if ($string =~ m/^\d*([\.,]\d+)?$/);
    return($string);
}

################################################################################
sub _cutExte {
    my $string = shift;
       $string =~ s/\..*$//;
    return($string);
}

################################################################################
sub _replace {
    my $string = shift;
       $string =~ s/\.\.\./_#PUNTINI#_/g;
    return($string);
}

################################################################################
sub _ecalper {
    my $string = shift;
       $string =~ s/_#PUNTINI#_/\.\.\./g;
    return($string);
}
