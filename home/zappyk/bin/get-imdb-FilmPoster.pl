#!/bin/env perl
$|=1;

use strict;
use warnings;

use URI::Escape;
use WWW::Mechanize;
use File::Basename;

my $this = basename($0);

my @list_ext   = ('.avi', '.mkv', '.mp4');
my @list_canc  = ('.CD1', '.CD2');

my $film_movie = $ARGV[0] || die("use: $this \"<title|film-movie>\"\n");
my $file_movie = basename($film_movie, @list_ext);
my $film_title = basename($file_movie, @list_canc);
my $film_dir   = dirname($film_movie);
my $debug      = $ARGV[1] || 0;

my $url_base = 'http://www.imdb.com';
my $url_find = $url_base.'/find?q=';
my $pag_find = 'class="primary_photo"';
my $row_find = ' id="primary-img" title="';
my $ext_name = '.jpg';
my $rem_bash = '#';
my $cmd_wget = 'wget -cq';
my $log_wget = "%1s $cmd_wget \"%s\" -O \"$film_dir/%s$ext_name\"";
my $log_echo = 'the url Title|Film-Movie %-50s not found! (%s)';
my $www_mech = WWW::Mechanize->new();

my @url_images = _getImages2Try($film_title);

if (scalar(@url_images) == 0) {
    _log(sprintf($log_echo, "\"$film_title\"", $film_movie));
} else {
    foreach my $url_image (@url_images) {
        my $rem_shell = ($url_image eq '')?$rem_bash:'';
        printf("$log_wget\n", $rem_shell, $url_image, $file_movie);
    }
}

exit;

################################################################################
sub _getImages2Try {
    my $film_title = shift;
    my @url_images = _getImages($film_title);

    if (scalar(@url_images) == 0) {
        _debug("get url image not found=[ $film_title ]", 1);

        my $film_title_new = $film_title;
           $film_title_new =~ s/\s+\(\d\d\d\d\)//;

        if ($film_title ne $film_title_new) {

            _debug("try url image change to=[ $film_title_new ], 1");

            @url_images = _getImages($film_title_new);

        }
    }

    return(@url_images);
}

################################################################################
sub _getImages {
    my $film_title = shift;
    my $film_uri   = _uriEscape($film_title);
    my $url        = $url_find.$film_uri;

    my @url_images = ();

    _debug("get url: $url", 1);
    my @url_pages = _getURLPages(1, _getContent($url));
    foreach my $url_page (@url_pages) {
        _debug("url_page: $url_page", 2);
        my @url_page_contents  = _getContent($url_page);

        my $url_media          = _getURLMedia(@url_page_contents);
        my @url_media_contents = _getContent($url_media);
        _debug("url_media: $url_media", 2);

        my $url_image          = _getURLImage(@url_media_contents);
        _debug("url_image: $url_image", 2);

    #CZ#push(@url_images, $url_image);
        push(@url_images, $url_image) if ($url_image);
    }

    return(@url_images);
}

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

    $www_mech->get($url);

    my $content  = $www_mech->content();
    my @contents = split("\n", $content, -1);

    return(@contents);
}

################################################################################
sub _getURLPages {
    my $first    = shift || 0;
    my @contents = @_;

    my @url_pages = ();

    foreach my $row (@contents) {
        if ($row =~ m/$pag_find/) {
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
        if ($row =~ m/$row_find/) {
            if ($row =~ m/ src="(.*)"\s+\/>/) {
                $row_image = $1;
                last;
            }
        }
    }

    return($row_image);
}

################################################################################
sub _debug {
    my $string = shift;
    my $levels = shift || 1;
    _log($string) if ($debug && ($debug >= $levels));
}

################################################################################
sub _log {
    my $string = shift;
    printf("$rem_bash %s\n", $string);
}
