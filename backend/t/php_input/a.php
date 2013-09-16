<?
$a = split("www", "coffeewwwpandas",1);
$q = split("www", "coffeewwwpandas");
$b= split("/www/", "coffeewwwpandas");
$c = preg_split("/www/i", "coffeewwwpandas");
$d = spliti("www", "coffeewwwpandas",1);
print $a[0];
print "\n";
print $b[0];
print "\n";
print $c[0];
$date = "04/30/1973";
list($month, $day, $year) = split('[/.-]', $date);
echo "Month: $month; Day: $day; Year: $year<br />\n";
if (hash_hmac("md5",$date,"panda") == $date) {
   echo "sad pandas\n";
}
$date_md5_hmac = hash_hmac("md5",$date,"panda");
if (hash_hmac("md5",$date,"panda") == $date_md5_hmac) {
   echo "happy pandas\n";
}
?>