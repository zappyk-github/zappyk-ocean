#!/bin/env perl
$|=1;

use strict;
use warnings;

use URI::Escape;
use WWW::Mechanize;
use File::Basename;

my $this = basename($0);

my $film_title = $ARGV[0] || die("use: $this \"<film-title>\"\n");
my $film_uri   = _uriEscape($film_title);
my $film_dir   = $ARGV[1] || '';
my $debug      = $ARGV[2] || 0;

my $url_base = 'http://www.imdb.com';
my $url_find = $url_base.'/find?q=';
my $row_find = 'class="primary_photo"';
my $ext_name = '.jpg';
my $cmd_wget = "%1swget -cq \"%s\" -O \"$film_dir%s$ext_name\"";
my $rem_bash = '#';

my $mech = WWW::Mechanize->new();
my $url  = $url_find.$film_uri;

my @url_pages = _getURLPages(1, _getContent($url));
foreach my $url_page (@url_pages) {
    my @url_page_contents  = _getContent($url_page);

    my $url_media          = _getURLMedia(@url_page_contents);
    my @url_media_contents = _getContent($url_media);

    my $url_image          = _getURLImage(@url_media_contents);
    my $get_image          = ($url_image eq '')?$rem_bash:'';

    my $wget = sprintf($cmd_wget, $get_image, $url_image, $film_title);

    if ($get_image eq $rem_bash) {
        printf("echo 'Film:  %-40s  poster not found!'\n", "\"$film_title\"");
    } else {
        printf("%s\n", $wget);
    }
}

exit;

################################################################################
sub _uriEscape {
    my $string = shift;
       $string = uri_escape($string);
       $string =~ s/%20/\+/g;
    return($string);
}

################################################################################
sub _getContent {
    my $url = shift;

    $mech->get($url);

    my $content  = $mech->content();
    my @contents = split("\n", $content, -1);

    return(@contents);
}

################################################################################
sub _getURLPages {
    my $first    = shift || 0;
    my @contents = @_;

    my @url_pages = ();

    foreach my $row (@contents) {
        if ($row =~ m/$row_find/) {
            if ($row =~ m/<a href="(.*)"\s+><img src="/) {
                my $url_page = $1;
                push(@url_pages, $url_base.$url_page);
                last if ($first);
            }
        }
    }

    return(@url_pages);
}

################################################################################
sub _getURLMedia {
    my @contents = @_;

    my $row_media = '';

    foreach my $row (@contents) {
        if ($row =~ m/<a href="(\/media\/.*)"/) {
            $row_media = $url_base.$1;
            last;
        }
    }

    return($row_media);
}

################################################################################
sub _getURLImage {
    my @contents = @_;

    my $row_image = '';

    foreach my $row (@contents) {
        if ($row =~ m/ id="primary-img" title="/) {
            if ($row =~ m/ src="(.*)"\s+\/>/) {
                $row_image = $1;
                last;
            }
        }
    }

    return($row_image);
}
