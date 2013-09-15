#!/usr/bin/perl
# The purpose of this is to run the entire pipeline
# First step is to get the list of projects to consider which runs on a single host
# but we don't have to block on it
use strict;
use warnings;
use IO::Select;
use IO::Handle;
use IPC::Open2;
$|=1;

my ($badrepos, $fixstuff);
my ($verify_out, $verify_in) = (IO::Handle->new(), IO::Handle->new());

my %urls;

sub main() {
    setup_output();
    my ($bingin,$ghin,$bqin,$gharchivein) = (IO::Handle->new(), IO::Handle->new(), IO::Handle->new(), IO::Handle->new());
    my $testin = IO::Handle->new();
    print "($bingin,$ghin,$bqin)\n";

    open ($bingin , "perl targets.pl|");
    open ($ghin, "perl targets2.pl|");
    open ($bqin, "perl bigquerytargets.pl|");
    open ($gharchivein , "perl gharchive.pl|");
    #open ($testin, "cat testin|");
    # We only run the fixing on one local machine
    open($fixstuff, "|perl fix_pandas.pl");
    my $s = IO::Select->new();
    $s->add($bingin);
    $s->add($ghin);
    $s->add($bqin);
    $s->add($gharchivein);
    #$s->add($testin);
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
    # Tell verify we are done
    print $verify_out "quitquitquit\n";
    # Read the input back from the hosts as it becomes available
    while (my $line = <$verify_in>) {
	handle_possible_repo($line);
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
    # Local mode :)
    open2($verify_in, $verify_out, "perl verify.pl") or die "$!";
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
	    $verify_out->print("$line\n");
	    $urls{$line} = 1;
	}
    } else {
	print "skipping ".$line;
    }
}

main();
