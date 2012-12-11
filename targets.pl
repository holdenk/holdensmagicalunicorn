#!/usr/bin/perl

use Data::Dumper;
use Bing::Search;
use Bing::Search::Source::Web;
use Text::SpellChecker;
use Unicorn::Settings qw{ settings };
use strict;
use warnings;

my $settings = settings();
my $token = $settings->{"bing.token"};
my $user = $settings->{"bing.user"};
my $appid = $settings->{"bing.appid"};

print "using token:$token user:$user appid:$appid\n";

my $inc = 10;
my $offset = 0;
my $max = 100;
my @queries = ("readme.md site:raw.github.com",
	       "settings.py site:raw.github.com",
	       "readme.txt site:raw.github.com",
	       "readme.pod site:raw.github.com",
	       "hmac php site:raw.github.com");
foreach my $query (@queries) {
    while ($offset < $max) {
	my $search = Bing::Search->new();
	$search->AppId($appid);
	$search->Query();
	my $source = Bing::Search::Source::Web->new();
	$source->Web_Count(10);
	$source->Web_Offset($offset);
	my $hash = $source->params;
	$hash->{'web.offset'} = $offset;
	$source->params($hash);
	
	$search->add_source($source);
	
	my $response = $search->search();
	
	foreach my $result ( @{$response->results} ) {
	    if ($result->isa("Bing::Search::Result::Errors")) {
		print "error: ".Dumper($result)." in $response\n";
	    }
	    print $result->Url, "\n";
	}
	$offset += $inc;
    }
}

