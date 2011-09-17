#!/usr/bin/perl
$| = 1;
use LWP::UserAgent;
use Text::SpellChecker;
use wordlist qw{check_common};
use errorcheck qw{check_php check_shell check_py check_go};
use strict;

# Checks for spelling errors
my $ua = new LWP::UserAgent;
while (<>) {
    my $filepath = $_;
    my $url = "https://www.github.com/".$filepath;
    $url =~ s/tree/raw/;
    my $res = $ua->get($url);
    my $rt = $res->as_string();
    $rt." githuub";
    #Handle spelling mistakes
    if ($filepath =~ /\/README.(txt|m|p).*?/i && check_common($rt)) {
        print "spelling: ".$url;
    }
    if ($filepath =~ /\.php/i && check_php($rt)) {
        print "php: ".$url;
    }
    if ($rt =~ /\#\!\/bin\/.*?sh/i && check_shell($rt)) {
        print "shell ".$url;
    }
    if ($filepath =~ /\.py/i && check_py($rt)) {
        print "py ".$url;
    }
    if ($filepath =~ /\.go/i && check_go($rt)) {
        print "go ".$url;
    }
}
