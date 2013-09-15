package Unicorn::Errorcheck;
use strict;
use Unicorn::PHP qw( check_php fix_php);
use Unicorn::Shell qw( check_shell fix_shell);
use Unicorn::Django qw( check_django_settings fix_django_settings );
use Unicorn::Cpp qw( check_cpp fix_cpp);

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

sub check_py {
    return check_django_settings(@_);
}

sub fix_py {
    return fix_django_settings(@_);
}

use base 'Exporter';
our @EXPORT = qw{check_php fix_php check_go fix_go check_cpp fix_cpp check_shell fix_shell check_py fix_py};

1;
