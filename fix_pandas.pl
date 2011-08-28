#!/usr/bin/perl -s
$| = 1;
use LWP::UserAgent;
use Text::SpellChecker;
use Net::Twitter;
require('wordlist.pl');

my $c = 0;
my $token = "";
my $user = "";

my $consumer_key;
my $consumer_secret;

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
    if ($l =~ /error\:\s+https:\/\/www.github.com\/\/(.*?)[\s\n]/) {
	print "Checking $1\n";
	my $url = "https://www.github.com/".$1;
	$url =~ s/raw\/.*?\//raw\/master\//;
	my $res = $ua->get($url);
	my $rt = $res->as_string();
	$rt;
	if (check_common($rt)) {
	    print "Error found: $url\n";
	    handle_url($url);
	} else {
	    print "Error not found anymore :( in $rt\n";
	}
    }
}

sub handle_url {
    my $url = shift @_;
    if ($url =~ /http.*\/(.*?)\/(.*?)\/raw\/master\/(README.*)/) {
	my $ruser = $1;
	my $repo = $2;
	my $file = $3;
	print "u:".$ruser."\n";
	print "r:".$repo."\n";
	print "f:".$file."\n";
	#print "error: ".$url;
	my $url2 = "https://github.com/".$user."/$repo";
	my $res2 = $ua->get($url2);
	$c = $c+1;
	if (!$res2->is_success || ($c < 16 && $repo !~ //)) {
	    print "Missing repo $repo.\n";
	    my $fork_res = $ua->post("https://github.com/api/v2/json/repos/fork/$ruser/$repo",{login => $user,
	       token => $token});
	    print "attempting to fork resulted in ".$fork_res->as_string();
	    print "Sleeping 30 seconds for fork\n";
	    sleep (30);
	    print "Sleeping rand()*10\n";
	    sleep (10*rand());
	    #clone
	    print "runing: cd foo; git clone git\@github.com:$user/$repo.git || git clone git\@github.com:$user/$repo.git;cd ..";
	    `cd foo; git clone git\@github.com:$user/$repo.git || git clone git\@github.com:$user/$repo.git;cd ..`;
	    #Fix
	    my $t = "";
	    open (IN, "foo/$repo/$file") or die "Unable to open $file in $repo";
	    while ($j = <IN>) {
		$t = $t.$j;
	    }
	    close(IN);
	    open (OUT, ">foo/$repo/$file") or die "Unable to open $file in $repo";
	    my $t = fix_text($t);
	    print OUT $t;
	    close (OUT);
	    `cd foo;cd $repo; git commit -a -m \"Spelling correction in README\"; git push; sleep 1;git push; cd ..;cd ..`;
	    my $make_pull_req = 1;
	    if ($make_pull_req) {
		print "Sleeping 10 for github to catch up with teh push...\n";
		sleep(10);
		my $pull_request = $ua->post("https://github.com/api/v2/json/pulls/$ruser/$repo",{login => $user,
												  token => $token,
												  "pull[base]" => "master",
												  "pull[title]" => "Spelling fix",
												  "pull[body]" => "Fix a typo in README",
												  "pull[head]" => "$user:master"});
		my $pt = $pull_request->as_string();
		print "Pull request is ".$pt;
		if ($pt =~ /html_url":"(https:\/\/github.com.*?)\"/) {
		    my $url_to_link_to = $1;
		    my $twitter_text = "Fixing a spelling error in $ruser/$repo on github. (see $url_to_link_to for the pull req)";
		    print "twteeting :".$twitter_text;
		    $nt->update($twitter_text);
		}
	    }
	} else {
	    print "Allready have $repo from $url2 , skipping forward!\n";
	}
    }
    
}
