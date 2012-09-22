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
    chomp ($filepath);
    $filepath =~ s/^\///;
    my $url = "https://raw.github.com/".$filepath;
    $url =~ s/\/tree\/(.*?)\//\/master\//;
    my $res = $ua->get($url);
    my $rt = $res->decoded_content;
    my $tempfile = File::Temp->new();
    my $tempfileName = $tempfile->filename;
    open (my $out, ">$tempfileName");
    print $out $rt;
    close ($out);
    #Skip tests
    if ($filepath =~ /obsolete/i) {
	print "skipping $filepath\n";
	next;
    }
    if ($filepath =~ /\/README.(txt|m|p).*?/i && check_common($tempfileName, $rt)) {
        print "spelling: ".$url."\n";
    }
    if ($filepath =~ /\.php/i && check_php($tempfileName, $rt)) {
        print "php: ".$url."\n";
    }
    if ($rt =~ /\#\!\/bin\/.*?sh/i && check_shell($tempfileName, $rt)) {
        print "shell ".$url."\n";
    }
    if ($filepath =~ /\.py/i && check_py($tempfileName, $rt)) {
        print "py ".$url."\n";
    }
    if ($filepath =~ /\.go/i && check_go($tempfileName, $rt)) {
        print "go ".$url."\n;"
    }
}
