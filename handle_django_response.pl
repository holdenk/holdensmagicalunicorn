#!/usr/bin/perl
# Handle the response from django

use LWP::UserAgent;
use Net::Twitter;
use Pithub;
use Data::Dumper;

use strict;
use Unicorn::Wordlist qw{fix_text check_common};
use Unicorn::Errorcheck qw{check_php fix_php check_py fix_py check_go fix_go check_cpp fix_cpp check_shell fix_shell};
use Unicorn::Blacklist qw{ ok_to_update };
use Unicorn::Settings qw{ settings };

require "shared_fix.pl";

my $p = Pithub->new;

my $c = 0;
my $settings = settings();
my $consumer_key = $settings->{"twitter.consumer_key"};
my $consumer_secret = $settings->{"twitter.consumer_secret"};
my $user = $settings->{"github.user"};
my $token = $settings->{"github.token"};
my $mode = $settings->{"mode"};
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
my $u = Pithub::Users->new( token => $token );
my $result = $u->get;
my $url_out;


while (<>) {
    my ($url,$target_username,$message_txt,$twitter_txt,$patch_good) = split(/,/, $_);
    my $repo = "";
    if ($url =~ /https:\/\/github.com\/[^\/]+?\/([^\/]+?)\//) {
	$repo = $1;
    }
    if ($patch_good) {
	my $pu = Pithub::PullRequests->new(user => $user ,token => $token);
	my $result = $pu->create(user => $target_username,
				 repo => $repo,
				 data => {
				     title => "Pull request to a fix things",
				     body => $message_txt,
				     base => "master",
				     head => "$user:"."master"});
	my $link = $result->content->{_links}->{html}->{href};
	#Post to twitter
	$twitter_txt =~ s/\[LINK\]$/$link/;
	$nt->update($twitter_txt);
    }    
}
