package errorcheck;
use strict;
use php;
use shell;


sub check_go {
    my $file = shift @_;
    my $rt = shift @_;
    return 1;
}
sub fix_go {
    my $filename = shift @_;
    `gofix "$filename"`;
    return 1;
}
sub check_cpp {
    return 0;
}
sub fix_cpp {
    my $file = shift @_;
    my $rt = shift @_;
    return $rt;
}

use base 'Exporter';
our @EXPORT = qw{check_php fix_php check_go fix_go check_cpp fix_cpp check_shell fix_shell};

1;
