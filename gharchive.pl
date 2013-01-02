#!/usr/bin/perl
# Fetch from gh archive..
use strict;
use warnings;
use File::Temp qw/ tempdir/;
use PerlIO::gzip;
use JSON;
my $dir = tempdir( CLEANUP => 1);
my $dirname = $dir->dirname;
my $wget_status;
open ($wget_status, "cd $dirname; wget http://data.githubarchive.org/{2012..2013}-{01..12}-{01..31}-{0..23}.json.gz|");
$json = JSON->new->allow_nonref;
while (my $line = <$wget_status>) {
    if ($line =~ /\`([\d\-]+\.json\.gz)\'\s+saved/) {
	my $event_filename = $1;
	print "Fetched ".$event_filename." processing\n";
	my $event_file;
	open($event_file, "<:gzip" , $event_filename) or die $!;
	while (my $event_txt = <$event_file>) {
	    my $event = $json->decode( $event_txt );
	    print $event->{"repo"}->{"url"};
	}
	close($event_file);
    }
}
close($wget_status);

