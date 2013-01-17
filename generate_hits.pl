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
print $out "diff_url1,msg1,user1,diff_url2,msg2,user2,diff_url3,msg3,user3,diff_url4,msg4,user4,diff_url5,msg5,user5,diff_url6,msg6,user6,diff_url7,msg7,user7,diff_url8,msg8,user8,diff_url9,msg9,user9,diff_url10,msg10,user10,diff_url11,msg11,user11\n";
my $urlcount = 0;
#hitinfo should contain url,msg,ruser
while ($hitinfo = <>) {
    $urlcount++;
    chomp ($hitinfo);
    print $out "$hitinfo";
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
	print $out "diff_url1,msg1,user1,diff_url2,msg2,user2,diff_url3,msg3,user3,diff_url4,msg4,user4,diff_url5,msg5,user5,diff_url6,msg6,user6,diff_url7,msg7,user7,diff_url8,msg8,user8,diff_url9,msg9,user9,diff_url10,msg10,user10,diff_url11,msg11,user11\n";
    }
}
close ($out);
