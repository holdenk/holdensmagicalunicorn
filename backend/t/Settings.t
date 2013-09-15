#Test the shell script thing
use Test::More tests => 1;
use Unicorn::Settings qw (settings);
use strict;

my $settings = settings();
is($settings->{"bing.token"},"BINGTOKEN");

