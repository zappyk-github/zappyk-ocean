#!/bin/env bash

yum install\
 mythtv\
 mythtv-backend\
 mythtv-base-themes\
 mythtv-common\
 mythtv-docs\
 mythtv-frontend\
 mythtv-libs\
 mythtv-setup\
 mythtv-status\
&& systemctl start mysqld.service\
&& mysql -u root < /usr/share/doc/mythtv-docs-0.24.1/database/mc.sql\

#=============================================================================================================================================================
# Pacchetto                                         Arch                     Versione                                  Repository                        Dim.
#=============================================================================================================================================================
#Installazione:
# mythtv                                            i686                     0.24.1-4.fc16                             rpmfusion-free                    23 k
# mythtv-backend                                    i686                     0.24.1-4.fc16                             rpmfusion-free                   984 k
# mythtv-base-themes                                i686                     0.24.1-4.fc16                             rpmfusion-free                    12 M
# mythtv-common                                     i686                     0.24.1-4.fc16                             rpmfusion-free                   373 k
# mythtv-docs                                       i686                     0.24.1-4.fc16                             rpmfusion-free                   233 k
# mythtv-frontend                                   i686                     0.24.1-4.fc16                             rpmfusion-free                   2.9 M
# mythtv-libs                                       i686                     0.24.1-4.fc16                             rpmfusion-free                   9.7 M
# mythtv-setup                                      i686                     0.24.1-4.fc16                             rpmfusion-free                   133 k
# mythtv-status                                     noarch                   0.9.0-5.fc15                              rpmfusion-free                    32 k
#Installazioni per dipendenze:
# GraphicsMagick                                    i686                     1.3.12-6.fc16                             fedora                           2.3 M
# ImageMagick-perl                                  i686                     6.7.0.10-4.fc16                           updates                          136 k
# MySQL-python                                      i686                     1.2.3-3.fc16                              fedora                            78 k
# PyGreSQL                                          i686                     4.0-3.fc16                                fedora                            70 k
# crystalhd-firmware                                noarch                   3.5.1-1.fc14                              fedora                           1.1 M
# dvdauthor                                         i686                     0.7.0-4.fc16                              fedora                           179 k
# lame                                              i686                     3.98.4-1.fc14                             rpmfusion-free                   108 k
# libcrystalhd                                      i686                     3.5.1-1.fc14                              fedora                            49 k
# mysql                                             i686                     5.5.17-1.fc16                             updates                          4.7 M
# mysql-server                                      i686                     5.5.17-1.fc16                             updates                          8.3 M
# mytharchive                                       i686                     0.24.1-4.fc16                             rpmfusion-free                    12 M
# mythbrowser                                       i686                     0.24.1-4.fc16                             rpmfusion-free                    96 k
# mythgallery                                       i686                     0.24.1-4.fc16                             rpmfusion-free                   201 k
# mythgame                                          i686                     0.24.1-4.fc16                             rpmfusion-free                   196 k
# mythmusic                                         i686                     0.24.1-4.fc16                             rpmfusion-free                   769 k
# mythnetvision                                     i686                     0.24.1-4.fc16                             rpmfusion-free                    15 M
# mythnews                                          i686                     0.24.1-4.fc16                             rpmfusion-free                   133 k
# mythplugins                                       i686                     0.24.1-4.fc16                             rpmfusion-free                    29 k
# mythvideo                                         i686                     0.24.1-4.fc16                             rpmfusion-free                   503 k
# mythweather                                       i686                     0.24.1-4.fc16                             rpmfusion-free                   435 k
# mythweb                                           i686                     0.24.1-4.fc16                             rpmfusion-free                   1.3 M
# mythzoneminder                                    i686                     0.24.1-4.fc16                             rpmfusion-free                   144 k
# perl-CGI                                          noarch                   3.52-190.fc16                             updates                          202 k
# perl-Class-Factory-Util                           noarch                   1.7-10.fc16                               fedora                            17 k
# perl-Class-Inspector                              noarch                   1.25-2.fc16                               fedora                            30 k
# perl-Class-Load                                   noarch                   0.12-1.fc16                               updates                           22 k
# perl-Class-Singleton                              noarch                   1.4-10.fc16                               fedora                            17 k
# perl-Convert-BinHex                               noarch                   1.119-16.fc16                             fedora                            43 k
# perl-DBD-MySQL                                    i686                     4.019-3.fc16                              fedora                           139 k
# perl-Data-OptList                                 noarch                   0.107-2.fc16                              fedora                            13 k
# perl-Date-Manip                                   noarch                   6.25-1.fc16                               fedora                           1.3 M
# perl-DateTime                                     i686                     2:0.70-2.fc16                             fedora                           107 k
# perl-DateTime-Format-Builder                      noarch                   0.8000-7.fc16                             fedora                            83 k
# perl-DateTime-Format-ISO8601                      noarch                   0.07-7.fc16                               fedora                            25 k
# perl-DateTime-Format-Strptime                     noarch                   1.5000-4.fc16                             fedora                            29 k
# perl-DateTime-Locale                              noarch                   0.45-1.fc16                               fedora                           1.6 M
# perl-DateTime-TimeZone                            noarch                   1.42-1.fc16                               updates                          312 k
# perl-Email-Date-Format                            noarch                   1.002-10.fc16                             fedora                            16 k
# perl-FCGI                                         i686                     1:0.74-1.fc16                             fedora                            40 k
# perl-HTML-Tree                                    noarch                   1:4.2-3.fc16                              fedora                           209 k
# perl-Image-Size                                   noarch                   3.2-7.fc16                                fedora                            44 k
# perl-List-MoreUtils                               i686                     0.32-3.fc16                               fedora                            53 k
# perl-MIME-Lite                                    noarch                   3.027-7.fc16                              fedora                            89 k
# perl-MIME-Types                                   noarch                   1.31-2.fc16                               fedora                            35 k
# perl-MIME-tools                                   noarch                   5.502-2.fc16                              fedora                           251 k
# perl-MailTools                                    noarch                   2.08-2.fc16                               fedora                           105 k
# perl-Math-Round                                   noarch                   0.06-10.fc16                              fedora                            13 k
# perl-Module-Runtime                               noarch                   0.011-1.fc16                              updates                           15 k
# perl-MythTV                                       i686                     0.24.1-4.fc16                             rpmfusion-free                    43 k
# perl-Net-SMTP-SSL                                 noarch                   1.01-8.fc16                               fedora                           8.4 k
# perl-Net-UPnP                                     noarch                   1:1.4.2-7.fc16                            fedora                            63 k
# perl-Package-DeprecationManager                   noarch                   0.11-2.fc16                               fedora                            17 k
# perl-Package-Stash                                noarch                   0.32-1.fc16                               fedora                            32 k
# perl-Package-Stash-XS                             i686                     0.25-1.fc16                               fedora                            28 k
# perl-Params-Classify                              i686                     0.013-3.fc16                              fedora                            25 k
# perl-Params-Util                                  i686                     1.04-2.fc16                               fedora                            35 k
# perl-Params-Validate                              i686                     1.00-3.fc16                               fedora                            64 k
# perl-SOAP-Lite                                    noarch                   0.712-8.fc16                              fedora                           325 k
# perl-Sub-Install                                  noarch                   0.925-9.fc16                              fedora                            20 k
# perl-Try-Tiny                                     noarch                   0.09-2.fc16                               fedora                            18 k
# perl-XML-LibXML                                   i686                     1:1.74-2.fc16                             fedora                           343 k
# perl-XML-NamespaceSupport                         noarch                   1.11-5.fc16                               fedora                            17 k
# perl-XML-Parser                                   i686                     2.41-3.fc16                               fedora                           220 k
# perl-XML-SAX                                      noarch                   0.96-15.fc16                              fedora                            79 k
# perl-XML-Simple                                   noarch                   2.18-10.fc16                              fedora                            72 k
# perl-XML-XPath                                    noarch                   1.13-15.fc16                              fedora                            80 k
# perl-YAML-Syck                                    i686                     1.17-3.fc16                               fedora                            79 k
# perl-parent                                       noarch                   1:0.225-190.fc16                          updates                           32 k
# php-process                                       i686                     5.3.8-3.fc16                              fedora                            37 k
# postgresql-libs                                   i686                     9.1.1-1.fc16                              fedora                           211 k
# python-MythTV                                     i686                     0.24.1-4.fc16                             rpmfusion-free                   208 k
# python-formencode                                 noarch                   1.2.2-4.fc15                              fedora                           236 k
# python-imdb                                       i686                     4.7-1.fc16                                fedora                           337 k
# python-lxml                                       i686                     2.3-1.fc16                                fedora                           606 k
# python-sqlite2                                    i686                     1:2.3.5-4.fc15                            fedora                            79 k
# python-sqlobject                                  noarch                   0.15.0-2.fc15                             fedora                           358 k
# qt-mysql                                          i686                     1:4.8.0-0.23.rc1.fc16                     fedora                            68 k
#
#Riepilogo della transazione
#=============================================================================================================================================================
#Install      86 Packages
#
#Dimensione totale del download: 83 M
#Dimensione installata: 195 M
