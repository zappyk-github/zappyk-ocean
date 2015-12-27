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
my $row_find = 'class="primary_photo"';
my $ext_name = '.jpg';
my $rem_bash = '#';
my $cmd_wget = "%1swget -cq \"%s\" -O \"$film_dir/%s$ext_name\"";
my $cmd_echo = "echo 'Title|Film-Movie:  %-50s  poster not found! (%s)'";
my $www_mech = WWW::Mechanize->new();

my @url_images = _getImages2Try($film_title);

if (scalar(@url_images) == 0) {
    printf("$cmd_echo\n", "\"$film_title\"", $film_movie);
} else {
    foreach my $url_image (@url_images) {
        my $get_image = ($url_image eq '')?$rem_bash:'';
        printf("$cmd_wget\n", $get_image, $url_image, $file_movie);
    }
}

exit;

################################################################################
sub _getImages2Try {
    my $film_title = shift;
    my @url_images = _getImages($film_title);

    if (scalar(@url_images) == 0) {
        _log("get url image not found=[ $film_title ]");

        my $film_title_new = $film_title;
           $film_title_new =~ s/\s+\(\d\d\d\d\)//;

        _log("try url image change to=[ $film_title_new ]");

        @url_images = _getImages($film_title_new);
    }

    return(@url_images);
}

################################################################################
sub _getImages {
    my $film_title = shift;
    my $film_uri   = _uriEscape($film_title);
    my $url        = $url_find.$film_uri;

    my @url_images = ();

    _debug("get url: $url");
    my @url_pages = _getURLPages(1, _getContent($url));
    foreach my $url_page (@url_pages) {
        _debug("url_page: $url_page");
        my @url_page_contents  = _getContent($url_page);

        my $url_media          = _getURLMedia(@url_page_contents);
        my @url_media_contents = _getContent($url_media);
        _debug("url_media: $url_media");

        my $url_image          = _getURLImage(@url_media_contents);
        _debug("url_image: $url_image");

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

################################################################################
sub _debug {
    my $string = shift;
    _log($string) if ($debug);
}

################################################################################
sub _log {
    my $string = shift;
    printf("$rem_bash %s\n", $string);
}
