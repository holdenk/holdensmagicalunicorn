#!/usr/bin/perl
$| = 1;
use LWP::UserAgent;
use Text::SpellChecker;
use Unicorn::Wordlist qw{check_common};
use Unicorn::Errorcheck qw{check_php check_shell check_py check_go};
use File::Temp;
use strict;

# Checks for spelling errors
my $ua = new LWP::UserAgent;
while (<>) {
    my $filepath = $_;
    my $url = "https://www.github.com/".$filepath;
    $url =~ s/tree/raw/;
    my $res = $ua->get($url);
    my $rt = $res->as_string();
    my $tempfile = File::Temp->new();
    my $tempfileName = $tempfile->filename;
    open (my $out, ">$tempfileName");
    print $out $rt;
    close ($out);
    #Handle spelling mistakes
    if ($filepath =~ /\/README.(txt|m|p).*?/i && check_common($tempfileName, $rt)) {
        print "spelling: ".$url;
    }
    if ($filepath =~ /\.php/i && check_php($tempfileName, $rt)) {
        print "php: ".$url;
    }
    if ($rt =~ /\#\!\/bin\/.*?sh/i && check_shell($tempfileName, $rt)) {
        print "shell ".$url;
    }
    if ($filepath =~ /\.py/i && check_py($tempfileName, $rt)) {
        print "py ".$url;
    }
    if ($filepath =~ /\.go/i && check_go($tempfileName, $rt)) {
        print "go ".$url;
    }
}
