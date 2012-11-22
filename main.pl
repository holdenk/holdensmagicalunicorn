#!/usr/bin/perl
# The purpose of this is to turn the entire pipeline, possibly on multiple machines
# First step is to get the list of projects to consider which runs on a single host
# but we don't have to block on it
use strict;
use warnings;
use IO::Select;
use IPC::Open2;
$|=1;

my $remoteoutselect = IO::Select->new();
my $remoteinselect = IO::Select->new();
my ($badrepos, $fixstuff);

sub main() {
    setup_output();
    my ($bingin,$ghin,$bqin);

    open ($bingin , "perl targets.pl\| tee bingtargets |");
    open ($ghin, "perl targets2.pl\| tee ghtargets |");
    open ($bqin, "perl bigquerytargets.pl\| tee bqtargets|");
    open ($fixstuff, "|perl fix_pandas.pl\| tee fixdata");
    my $s = IO::Select->new();
    $s->add($bingin);
    $s->add($ghin);
    $s->add($bqin);
    while (my @ready = $s->can_read) {
	foreach my $fh (@ready) {
	    my $line = <$fh>;
	    handle_line($line);
	}
    }
    my @ready;
    # Read the input back from the hosts as it becomes available
    while (@ready = $remoteinselect->can_read(60) && @ready != ()) {
	for my $fh (@ready) {
	    handle_possible_repo(<$fh>);
	}
    }
    # Tell all of the children we are done
    my @outputhandles = $remoteoutselect->can_write;
    for my $fh (@outputhandles) {
	print $fh "quitquitquit\n";
	sleep 5;
	print $fh "exit\n";
    }
    # Read any remaining input back from the hosts
    while (@ready = $remoteinselect->can_read(60) && @ready != ()) {
	for my $fh (@ready) {
	    handle_possible_repo(<$fh>);
	}
    }
    close ($badrepos);
}

sub handle_possible_repo {
    my $repo = shift @_;
    if ($repo =~ /http/) {
	print $badrepos $repo;
	print $fixstuff $repo;
    }
}

sub setup_output {
    my $hosts;
    open ($hosts, "hosts.txt");
    print "Clean up old distro tarball\n";
    `rm magic.tar.bz2; rm magic.tar`;
    print "Making new distro tarball\n";
    `tar -cf ./magic.tar ./; tar -Af ./magic.tar ../settings.yml`;
    print "Compressing\n";
    `bzip2 magic.tar`;
    while (my $hostline = <$hosts>) {
	my @murh = split(/\:/,$hostline);
	my $hostname = $murh[0];
	my $pwd = $murh[1];
	print "Updating host $hostname\n";
	`scp magic.tar.bz2 $hostname:~/`;
	my ($child_out,$child_in);
	open2($child_in, $child_out, "ssh -t -t $hostname");
	#hack
	sleep 1;
	print $child_out "mkdir $pwd;cd $pwd;cp ~/mymagic.tar ./;tar -xvf mymagic.tar;export PATH=$pwd/bin:\$PATH;perl verify.pl";
	$remoteoutselect->add($child_out);
	$remoteinselect->add($child_in);
    }
    open ($badrepos , ">badrepos.txt");
}

sub handle_line {
    my $line = shift @_;
    
}

main();
