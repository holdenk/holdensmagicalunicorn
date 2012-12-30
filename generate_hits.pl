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
print $out "diff_url1,msg1,diff_url2,msg2,diff_url3,msg3,diff_url4,msg4,diff_url5,msg5,diff_url6,msg6,diff_url7,msg7,diff_url8,msg8,diff_url9,msg9,diff_url10,msg10,diff_url11,msg11\n";
my $urlcount = 0;
while ($url = <>) {
    $urlcount++;
    chomp ($url);
    print $out "$url";
    my $msg = <>;
    print $out ",$msg";
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
	print $out "diff_url1,msg1,diff_url2,msg2,diff_url3,msg3,diff_url4,msg4,diff_url5,msg5,diff_url6,msg6,diff_url7,msg7,diff_url8,msg8,diff_url9,msg9,diff_url10,msg10,diff_url11,msg11\n";
    }
}
close ($out);
