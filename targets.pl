#!/usr/bin/perl

use Bing::Search;
use Bing::Search::Source::Web;
use Text::SpellChecker;
use Unicorn::Settings qw{ settings };

my $settings = settings();
my $token = $settings->{"bing.token"};
my $user = $settings->{"bing.user"};
my $appid = $settings->{"bing.appid"};

my $inc = 10;
my $offset = 0;
my $max = 100;
@queries = ("readme.md site:raw.github.com",
	    "settings.py site:raw.github.com",
	    "readme.txt site:raw.github.com",
	    "readme.pod site:raw.github.com",
            "hmac php site:raw.github.com");
foreach my $query (@queries) {
    while ($offset < $max) {
	my $search = Bing::Search->new();
	$search->AppId($a);
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
	    print $result->Url, "\n";
	}
	$offset += $inc;
    }
}

