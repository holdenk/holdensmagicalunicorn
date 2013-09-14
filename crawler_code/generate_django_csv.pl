# Generate the import file for our frontend
use strict;
use warnings;
my $out;
my $batchsize = 100;
my $batchnum = 0;
while (-f "django_export/".$batchnum.".csv") {
    $batchnum++;
}
open ($out, ">django_export/".$batchnum.".csv");
print $out "diff_url,message_txt,target_username\n";
my $urlcount = 0;
#hitinfo should contain url,msg,ruser
while ($hitinfo = <>) {
    $urlcount++;
    chomp ($hitinfo);
    print $out "$hitinfo\n";
    if ($urlcount % $batchsize == 0) {
	close ($out);
	$batchnum++;
	open ($out, ">django_export/".$batchnum.".csv");
	print $out "diff_url,message_txt,twitter_txt,target_username\n";
    }
}
close ($out);
