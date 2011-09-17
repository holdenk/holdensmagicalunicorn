#!/usr/bin/perl
use LWP::UserAgent;
require HTML::LinkExtor;
use strict;

my $ua = new LWP::UserAgent;
my $max = 400;
my $v = 1;
my $inc = 1;
my @foo;

#Readme files
handle_search("Markdown","readme","(.*?README\.m.*?)\$");
handle_search("Text","readme.txt","(.*?\/README\.txt.*?)\$");
handle_search("Perl","readme.p","(.*?README\.p.*?)\$");
#PHP
handle_search("PHP","spliti","(.*?\.php)\$");
handle_search("PHP","ip2long","(.*?\.php)\$");
handle_search("PHP","mysql_db_query","(.*?\.php)\$");
#django
handle_search("Python","\"'ENGINE'%3A+'sqlite3'\"","(.*?settings.*?\.py)");
#bash
handle_search("Shell","bash","(.*?\/tree\/.*?\.)");
#go
handle_search("Go","nil","(.*\.go)");
my @links;
sub handle_search() {
    my $language = shift @_;
    my $q = shift @_;
    my $r = shift @_;
    print "handling $q!\n";
    my $v = 1;
    my $inc = 1;
    #Shaady loop through search results
    my $t = "/tree/";
    while ($t =~ /\/tree\//) {
        print "looping!: $v\n";
        my $url = "https://github.com/search?type=Code&language=".$language."&q=".$q."&repo=&langOverride=&x=27&y=30&start_value=$v";
        print "url: $url\n";
        my $res = $ua->get("$url");
        my $rt = $res->as_string();
        $t = $rt;
        @links = ();
        sub callback {
            my($tag, %attr) = @_;
            return if $tag ne 'a';  # we only look closer at <img ...>
            push(@links, values %attr);
        }
        my $p = HTML::LinkExtor->new(\&callback);
        $p->parse($rt);
        foreach my $link (@links) {
            if ($link =~ /tree/) {
                if ($link =~ /$r/) {
                    print "$link\n";
                } 
            }
        }
        $v += $inc;
        sleep 1;
    }
}
