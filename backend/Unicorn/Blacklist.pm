package Unicorn::Blacklist;

sub ok_to_update {
    my $user = shift @_;
    my %none = {"lolerskates" => 1};
    if ($none{$user}) {
        print "Not updating for $user ... :( \n";
        return 0;
    } else {
        return 1;
    }
}

use base 'Exporter';
our @EXPORT = qw{ok_to_update};

1;
