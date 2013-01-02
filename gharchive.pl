#!/usr/bin/perl
# Fetch from gh archive..
$| = 1;
use strict;
use warnings;
use File::Temp;
use PerlIO::gzip;
use JSON;
# Only consider repos with at least five events
my $threshold = 5;
my $dir = File::Temp->newdir( CLEANUP => 1);
my $dirname = $dir->dirname;
my $wget_status;
my %urls;
open ($wget_status, "bash -c \"cd $dirname; wget http://data.githubarchive.org/{2012..2013}-{01..12}-{01..31}-{0..23}.json.gz\" 2>&1|");
my $json = JSON->new->allow_nonref;
while (my $line = <$wget_status>) {
    if ($line =~ /\`([\d\-]+\.json\.gz)\'\s+saved/) {
	my $event_filename = $1;
	print "Fetched ".$event_filename." processing\n";
	my $event_file;
	open($event_file, "<:gzip" , $dirname."/".$event_filename) or die $!;
	while (my $event_txt = <$event_file>) {
	    my $event = $json->decode( $event_txt );
	    my $repourl = $event->{"repo"}->{"url"};
	    # Apparently they didn't want to put the actual url here, so rewrite it to something usable
	    $repourl =~ s/\/api.github.dev\/repos\//\/www.github.com\//;
	    $urls{$repourl}++;
	    if ($urls{$repourl} == $threshold) {
		print $repourl."\n";
	    }
	}
	close($event_file);
    }
}
close($wget_status);

