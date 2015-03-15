#!/usr/bin/perl

use strict;
use warnings;
 
use WWW::Mechanize;
use LWP::Debug qw( + );

my $domain = 'gmail.com';

my $base_www    = qq|https://www.google.com|;
   $base_www    = qq|https://accounts.google.com|;
my $base_mail   = qq|https://mail.google.com|;
my $path_export = qq|mail/contacts/data/export?groupToExport=%5EMine&exportType=ALL&out=|;
   $path_export = qq|mail/c/data/export?exportType=ALL&out=|;
my $path_last  = qq|&tok=|;
my $path_auth   = qq|accounts/ServiceLoginBoxAuth|;
   $path_auth   = qq|ServiceLogin|;

###########
# EXAMPLE #
###########
# https://accounts.google.com/ServiceLogin
# https://mail.google.com/mail/c/data/export?exportType=ALL&out=OUTLOOK_CSV&tok=cvyufzMBAAA.dL5535OjxbxaB7sQ9IvsFA.VMiUahG0hoBluoQYGNsrMA
# https://mail.google.com/mail/c/data/export?exportType=ALL&out=GMAIL_CSV&tok=cvyufzMBAAA.dL5535OjxbxaB7sQ9IvsFA.VMiUahG0hoBluoQYGNsrMA
# https://mail.google.com/mail/c/data/export?exportType=ALL&out=VCARD&tok=cvyufzMBAAA.dL5535OjxbxaB7sQ9IvsFA.VMiUahG0hoBluoQYGNsrMA

my $url_loginAuth   = "$base_www/$path_auth";
my $url_CSV_OUTLOOK = "$base_mail/$path_export".'OUTLOOK_CSV'.$path_last;
my $url_CSV_GMAIL   = "$base_mail/$path_export".'GMAIL_CSV'.$path_last;
my $url_VCARD       = "$base_mail/$path_export".'VCARD'.$path_last;

my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
   $mon += 1;
   $year+= 1900;
my $date = sprintf("%04d%02d%02d", $year, $mon, $mday);

#CZ#print('Download ALL contacts for user? ');
#CZ#my $user = <STDIN>; chomp($user);
#CZ#my $account_user = join('@', $user, $domain);
print('Download ALL contacts for user@domain? ');
my $account_user = <STDIN>; chomp($account_user);
print("Password for $account_user? ");
my $account_pswd = <STDIN>; chomp($account_pswd);

$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
 
my $mech = WWW::Mechanize->new();

my %contacts = (
    $url_CSV_OUTLOOK => "contacts-google-$account_user-$date-outlook.csv",
    $url_CSV_GMAIL   => "contacts-google-$account_user-$date.csv",
    $url_VCARD       => "contacts-google-$account_user-$date.vcf"
);
 
printf("%s... ", 'Login ongoing');
$mech->get($url_loginAuth);
$mech->field('Email', $account_user);
$mech->field('Passwd', $account_pswd);
$mech->submit();
printf("%s\n", 'done!');
 
foreach my $url (keys %contacts) {
printf("Download '%s' ==> %s\n", $url, $contacts{$url});
$mech->get($url, ':content_file' => $contacts{$url});
warn("Download of google contacts did not work: $!") if (! $mech->success());
}

exit;
