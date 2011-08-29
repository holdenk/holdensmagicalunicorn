#!/usr/bin/perl
$| = 1;
use LWP::UserAgent;
use Text::SpellChecker;
use wordlist qw{check_common};

my $ua = new LWP::UserAgent;
print "Hello!\n";
while (<>) {
    print "Checking $_\n";
    my $url = "https://www.github.com/".$_;
    $url =~ s/tree/raw/;
    my $res = $ua->get($url);
    my $rt = $res->as_string();
    $rt." githuub";
    if (check_common($rt)) {
	print "error: ".$url;
    }
}
