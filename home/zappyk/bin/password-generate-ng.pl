#!/usr/bin/perl

printf("%s\n", randomPassword($ARGV[0]));

exit;

sub randomPassword {
    my $password_length = shift || 8;

    my $password;
    my $random;

    my @chars = split(" ",
    "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
     a b c d e f g h i j k l m n o p q r s t u v w x y z
     0 1 2 3 4 5 6 7 8 9 | ! $ % & / ( ) = ? ^ - _ @ # *");

    srand;

    for (my $i=1; $i <= $password_length ;$i++) {
        $random = int(rand scalar(@chars));
        $password .= $chars[$random];
    }

    return($password);
}
