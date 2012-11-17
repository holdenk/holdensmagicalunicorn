#!/usr/bin/perl

#The purpose of this code is to see if we might make a change to something otherwise output none
use strict;
use warnings;
$| = 1;
use LWP::UserAgent;
use Net::Twitter;
use Pithub;
use Data::Dumper;

use strict;
use Unicorn::Wordlist qw{fix_text check_common};
use Unicorn::Errorcheck qw{check_php fix_php check_py fix_py check_go fix_go check_cpp fix_cpp check_shell fix_shell};
use Unicorn::Blacklist qw{ ok_to_update };
#use Unicorn::Settings qw{ settings }:

require "shared_fix.pl";

my $p = Pithub->new;
while (my $l = <>) {
    if ($l =~ /github\.com\/(.*?)\s*$/) {
        my $url = "https://www.github.com/".$1;
        $url =~ s/raw\/.*?\//raw\/master\//;
        handle_url($url);
    } elsif ($l =~ /quitquit/) {
	exit;
    } else {
        print "fuck\n";
    }
}

sub handle_url {
    my $url = shift @_;
    if ($url =~ /http.*\/.*github\.com\/(.*?)\/(.*?)(\/|$).*/) {
        my $ruser = $1;
        my $repo = $2;
        my $result = $p->repos->get( user => $ruser , repo => $repo);
        my $traverse = 0;
        #Do we need to go up a level?
        while ($traverse < 10 && $result->content->{source}) {
            my $above = $result->content->{source}->{url};
            if ($above =~ /repos\/(.*?)\/(.*)$/) {
                $ruser = $1;
                $repo = $2;
            }
            $result = $p->repos->get( user => $ruser , repo => $repo);
            $traverse++;
        }
	# Try and get the repo
	my $clone_url = $result->content->{clone_url};
        `rm -rf foo && mkdir -p foo && cd foo && git clone "$clone_url" && cd *`;
        #Get the files
        my @all_files;
        open (my $files,"find ./foo/|");
        while (my $file = <$files>) {
            chomp ($file);
            push @all_files, $file;
        }
        close ($files);
        #Now we iterate through each of the processors so the git commit messages are grouped logically
        my @changes = handle_files(@all_files);
        #Did we change anything?
        if ($#changes > 0) {
	    print "$url\n";
	    return 1;
        } else {
	    print "no win\n";
	}
    }
}
