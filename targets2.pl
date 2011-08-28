#!/usr/bin/perl
use LWP::UserAgent;

my $ua = new LWP::UserAgent;
my $max = 400;
my $v = 1;
my $inc = 1;
my @foo;
while ($v < $max) {
    my $url = "https://github.com/search?type=Code&language=Markdown&q=readme&repo=&langOverride=&x=27&y=30&start_value=$v";
    my $res = $ua->get("$url");
    my $rt = $res->as_string();
    while ($rt =~ s/\"(.*?README\.m.*?)\"//) {
	print "$1\n";
    }
    $v += $inc;
    sleep 10;
#    print "done, left with $rt\n";
#    exit;
}
