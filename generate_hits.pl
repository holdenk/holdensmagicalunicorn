# Generate the HITs for mechanical turk
use strict;
use warnings;
my $out;
my $batchsize = 100;
my $batchnum = 0;
while (-f "hits/".$batchnum.".csv") {
    $batchnum++;
}
open ($out, ">hits/".$batchnum.".csv");
print $out "diff_url1,diff_url2,diff_url3,diff_url4,diff_url5,diff_url6,diff_url7,diff_url8,diff_url9,diff_url10,diff_url11\n";
my $urlcount = 0;
while (<>) {
    $urlcount++;
    chomp ($_);
    print $out "$_";
    if ($urlcount % 11 == 0) {
	print $out "\n";
	$urlcount = 0;
    } else {
	print $out ",";
    }
    if ($urlcount % $batchsize == 0) {
	close ($out);
	$batchnum++;
	open ($out, ">hits/".$batchnum.".csv");
	print $out "diff_url1,diff_url2,diff_url3,diff_url4,diff_url5,diff_url6,diff_url7,diff_url8,diff_url9,diff_url10,diff_url11\n";
    }
}
close ($out);
