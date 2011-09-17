#!/usr/bin/perl -s
$| = 1;
use LWP::UserAgent;
use Net::Twitter;
use Pithub;
use Data::Dumper;

use wordlist qw{fix_text check_common};
use strict;

my $token ="";
my $user = "holdensmagicalunicorn";

my $p = Pithub->new;

my $consumer_key = "";
my $consumer_secret = "";


my $c = 0;
print "using ck $consumer_key / secret $consumer_secret\n";
my $nt = Net::Twitter->new(
    traits   => [qw/OAuth API::REST/],
    consumer_key        => $consumer_key,
    consumer_secret     => $consumer_secret,
);
$nt->access_token();
$nt->access_token_secret();

my $ua = new LWP::UserAgent;
print "Hello!\n";
print "Connecting to github!\n";
print "Reading input\n";
while (my $l = <>) {
    if ($l =~ /github\.com\/(.*?)\s*$/) {
        print "Checking $1\n";
        my $url = "https://www.github.com/".$1;
        $url =~ s/raw\/.*?\//raw\/master\//;
        handle_url($url);
    } else {
        print "fuck $l\n";
    }
}

sub handle_url {
    my $url = shift @_;
    print "looking at $url\n";
    if ($url =~ /http.*\/(.*?)\/(.*?)\/(raw\/|)(master|development)\/(.*)/) {
        my $ruser = $1;
        my $repo = $2;
        my $file = $4;
        print "u:".$ruser."\n";
        print "r:".$repo."\n";
        print "f:".$file."\n";
        my $result = $p->repos->get( user => $ruser , repo => $repo);
        my $traverse = 0;
        #Do we need to go up a level?
        while ($traverse < 10 && $result->content->{source}) {
            my $above = $result->content->{source}->{url};
            print "Yup, source exists was pulled from $above\n";
            if ($above =~ /repos\/(.*?)\/(.*)$/) {
                $ruser = $1;
                $repo = $2;
            }
            $result = $p->repos->get( user => $ruser , repo => $repo);
            $traverse++;
        }
        #Ok dokey lets try and fork this business
        my $f = Pithub::Repos::Forks->new(user => $user ,token => $token);
        my $result = $f->create( user => $ruser, repo => $repo);
        print "got back ".Dumper($result->content)."yay?";
        my $clone_url = $result->content->{ssh_url};
        my $upstream_url = $result->content->{parent}->{ssh_url};
        my $master_branch = $result->content->{parent}->{master_branch};
        #Oh hey lets merge the latest business to eh (just in case we have an old fork)
        `rm -rf foo && mkdir -p foo && cd foo && git clone "$clone_url" && cd * && git remote add upstream "$upstream_url" && git fetch upstream && git merge upstream/$master_branch && git push`;
        #Get the files
        my @all_files;
        open (my $files,"find ./foo/|");
        while (my $file = <$files>) {
            chomp ($file);
            push @all_files, $file;
        }
        close ($files);
        #Now we iterate through each of the processors so the git commit messages are grouped logically
        
    }
}
sub fix_readme {
    my $file = shift @_;
    if ($file =~ /\/README(\.txt|\.rtf|\.md|\.m\w+)$/) {
        print "Checking $file for readme changes";
        open (my $in, "<", "$file") or die "Unable to open $file in $repo";
        my $t = do { local $/ = <$in> };
        close($in);
        #Is there a spelling mistake?
        if (check_common($t)) {
            open ($out, ">", "$file") or die "Unable to open $file in $repo";
            print $out fix_text($t);
            close ($out);
        }
    } elsif ($file =~ /\/README\.pod$/) {
        #Handle pod l8r
    }
}

