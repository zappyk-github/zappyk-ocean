#!/usr/bin/perl
srand(time() ^ ($$ + $$ << 21));
 
if($ARGV[0] eq "") {
        print "You must enter the number of passwords you want created.\n";
        exit(0);
}
$howMany = $ARGV[0] - 1;
 
$siz = 8;
$siz = 6 if ($siz < 6);
 
$addConsonants = 1;
$firstUpper = 1;
$mixedCase = 1;
$symbolOdds = 7;
$across = 0;
 
$sym = '~`!@#$%^&*()-_+=,.<>';
$numb = "0123456789" . $sym;
$lnumb = length($numb);
$upr = "BCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz";
$cons = "bcdfghjklmnpqrstvwxyz";
 
if ($mixedCase) {
    $vowel = "AEIOUaeiou";
    $cons = $upr;
} else {
    $vowel = "aeiou";
}
$upr = $cons unless ($firstUpper);
$lvowel = length($vowel);
$lcons = length($cons);
$lupr = length($upr);
 
$realSize = $siz;
$realSize += 2 if ($addConsonants);
($across) ? ($down = "  ") : ($down = "\n");
$linelen = 0;
 
for ($j=0; $j<=$howMany; $j++) {
   $pass = "";
   $k = 0;
   for ($i=0; $i<=$siz; $i++) {
      if ($i==0 or $i==2 or $i==5 or $i==7) {
         if ($i==0 or $i==5) {
            $pass .= substr($upr,int(rand($lupr)),1);
         } else {
            $pass .= substr($cons,int(rand($lcons)),1);
         }
         if ($addConsonants and (int(rand(4)) == 3) and $k < 2) {
            $pass .= substr($cons,int(rand($lcons)),1);
            $k++;
         }
      }
 
      if ($i > 7) {
          if (int(rand(26)) <= 5) {
             $pass .= substr($vowel,int(rand($lvowel)),1);
          } else {
             $pass .= substr($cons,int(rand($lcons)),1);
          }
      }
 
      $pass .= substr($vowel,int(rand($lvowel)),1)
         if ($i==1 or $i==6);
 
      if ($i==3 or $i==4) {
         if ($symbolOdds) {
            $pass .= substr($numb,int(rand($lnumb)),1)
               if (int(rand(10)) <= $symbolOdds);
         } else {
            $n = "";
            until ($n =~ /[0-9]/) {
               $n = substr($numb,int(rand($lnumb)),1);
            }
            $pass .= $n;
         }
      }
   }
 
   $skipThisOne = 0;
   $skipThisOne = 1 if ($pass =~ /[~`!@#$%^&*()\-_+=,.<>]{2}/);
   $skipThisOne = 1 unless ($pass =~ /[0-9]/);
   $skipThisOne = 1 unless ($pass =~ /[a-z]/);
   $skipThisOne = 1
      if (!($pass =~ /[A-Z]/) and ($firstUpper or $mixedCase));
   if ($skipThisOne) {
      $j--;
      next;
   }
   $pass = substr($pass,0,$realSize) if (length($pass) > $realSize);
 
   if ($down ne "\n") {
      if ($linelen + length($pass) + length($down) > 79) {
         print "\n";
         $linelen = 0;
      }
      $linelen += length($pass) + length($down);
   }
   print "$pass$down";
 
}

print "\n" if $down ne "\n";

exit;
