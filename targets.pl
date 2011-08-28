#!/usr/bin/perl

use Bing::Search;
use Bing::Search::Source::Web;
use Net::GitHub;
use Text::SpellChecker;

my $token = "";
my $user = "";

my $a = "";
my $inc = 10;
my $offset = 0;
my $max = 100;
while ($offset < $max) {
    my $search = Bing::Search->new();
    $search->AppId($a);
    $search->Query("blob/master/readme.md site:github.com");
    my $source = Bing::Search::Source::Web->new();
    $source->Web_Count(10);
    $source->Web_Offset($offset);
    my $hash = $source->params;
    $hash->{'web.offset'} = $offset;
    $source->params($hash);
    
    $search->add_source($source);
    
    my $response = $search->search();

    foreach my $result ( @{$response->results} ) {
	print $result->Title, " -> ", $result->Url, "\n";
    }
    $offset += $inc;
}
#
#print "Connecting to github!\n";
#my $github = Net::GitHub::V2->new(login => $user, token => $token);

