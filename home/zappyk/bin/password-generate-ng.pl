#!/usr/bin/perl

printf("%s\n", randomPassword($ARGV[0], $ARGV[1]));

exit;

sub randomPassword {
    my $password_length = shift || 12;
    my $password_repeat = shift || 1;

    my @passwords;
    my $password;
    my $random;

    my @chars = split(" ",
    "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
     0 1 2 3 4 5 6 7 8 9 ; : . , + ' 0 1 2 3 4 5 6 7 8 9
     0 1 2 3 4 5 6 7 8 9 | ! $ % & / ( ) = ? ^ - _ @ # *
     a b c d e f g h i j k l m n o p q r s t u v w x y z
     0 1 2 3 4 5 6 7 8 9 | ! $ % & / ( ) = ? ^ - _ @ # *");

    foreach (my $j=1; $j<=$password_repeat; $j++) {
	$password = "";
        for (my $i=1; $i <= $password_length ;$i++) {
            srand;
            $random = int(rand scalar(@chars));
            $password .= $chars[$random];
        }
        push(@passwords, $password);
    }

    return(join("\n", @passwords));
}
