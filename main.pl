#!/usr/bin/perl
# The purpose of this is to run the entire pipeline, possibly on multiple machines
# First step is to get the list of projects to consider which runs on a single host
# but we don't have to block on it
use strict;
use warnings;
use IO::Select;
use IO::Handle;
use IPC::Open2;
$|=1;

my $remoteoutselect = IO::Select->new();
my $remoteinselect = IO::Select->new();
my ($badrepos, $fixstuff);

my %urls;

sub main() {
    setup_output();
    my ($bingin,$ghin,$bqin,$gharchivein) = (IO::Handle->new(), IO::Handle->new(), IO::Handle->new(), IO::Handle->new());
    my $testin = IO::Handle->new();
    print "($bingin,$ghin,$bqin)\n";

#    open ($bingin , "perl targets.pl|");
#    open ($ghin, "perl targets2.pl|");
#    open ($bqin, "perl bigquerytargets.pl|");
#    open ($gharchivein , "perl gharchive.pl|");
    open ($testin, "cat testin|");
    # We only run the fixing on one local machine
    open($fixstuff, "|perl fix_pandas.pl");
    my $s = IO::Select->new();
#    $s->add($bingin);
#    $s->add($ghin);
#    $s->add($bqin);
#    $s->add($gharchivein);
    $s->add($testin);
    while (my @ready = $s->can_read()) {
	foreach my $fh (@ready) {
	    print "reading from $fh\n"; 
	    my $line;
	    if (defined ($line = $fh->getline)) {
		print "line is $line";
		handle_line($line);
	    } else {
		print "removing file handle $fh\n";
		$s->remove($fh);
	    }
	    sleep 1;
	}
    }
    # We no longer hanve any output for them so close the output handles.
    for my $fh ($remoteoutselect->handles) {
	$fh->close();
    }
    # Read the input back from the hosts as it becomes available
    while (my @ready = $remoteinselect->can_read(1200) && $#ready != 0) {
	for my $fh (@ready) {
	    print "reading line from $fh\n";
	    my $line;
	    if (defined ($line = $fh->getline)) {
		handle_possible_repo($line);
	    } else {
		$remoteoutselect->remove($fh);
	    }
	}
    }
    print "Telling children we are done\n";
    # Tell all of the children we are done
    my @outputhandles = $remoteinselect->can_write;
    for my $fh (@outputhandles) {
	$fh->print("quitquitquit\n");
	sleep 5;
	$fh->print("exit\n");
    }
    close ($badrepos);
}

sub handle_possible_repo {
    my $repo = shift @_;
    print "Handling possible bad repo $repo\n";
    chomp ($repo);
    if ($repo =~ /http/ && $repo =~ /github/) {
	print $badrepos $repo."\n";
	print $fixstuff $repo."\n";
    }
}

sub setup_output {
    my $hosts;
    open ($hosts, "hosts.txt");
    print "Clean up old distro tarball\n";
    `rm magic.tar.bz2; rm magic.tar`;
    print "Making new distro tarball\n";
    `tar --exclude-vcs  -cf ./magic.tar ./; tar -rf ./magic.tar ../settings.yml`;
    print "Compressing\n";
    `bzip2 magic.tar`;
    while (my $hostline = <$hosts>) {
	#Fuck comments
	if ($hostline =~ /^\#/) {
	    next;
	}
	my @murh = split(/\:/,$hostline);
	my $hostname = $murh[0];
	my $pwd = $murh[1];
	print "Updating host $hostname\n";
	`scp magic.tar.bz2 $hostname:~/`;
	my ($child_out,$child_in) = (IO::Handle->new(), IO::Handle->new());
	open2($child_in, $child_out, "ssh -t -t $hostname");
	#hack
	sleep 1;
	print $child_out "mkdir $pwd;cd $pwd;cp ~/mymagic.tar ./;tar -xvf mymagic.tar;export PATH=$pwd/bin:\$PATH;perl verify.pl";
	$remoteoutselect->add($child_out);
	$remoteinselect->add($child_in);
    }
    # Local mode :)
    my ($child_out,$child_in) = (IO::Handle->new(), IO::Handle->new());
    open2($child_in, $child_out, "perl verify.pl") or die "$!";
    $remoteoutselect->add($child_out);
    $remoteinselect->add($child_in);
    open ($badrepos , ">badrepos.txt");
}

# Handle it somewhere
sub handle_line {
    my $line = shift @_;
    if ($line =~ /http/) {
	chomp ($line);
	if ($urls{$line}) {
	    print "skipping $line allready seen\n";
	} else {
	    print "considering possibility ".$line."\n";
	    my @ready = $remoteoutselect->can_write(1);
	    my $j = int(rand($#ready));
	    my $outfh = $ready[$j];
	    $outfh->print("$line\n");
	    $urls{$line} = 1;
	}
    } else {
	print "skipping ".$line;
    }
}

main();
