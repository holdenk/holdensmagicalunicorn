package Unicorn::Cpp;
use strict;
use File::Basename;
use File::Slurp qw (slurp);

my $spatchexec = "spatch";
my $spatchdir = "cpp_semantic";

sub check_cpp {
    if (fast_check_cpp($file,$rt)) {
    }
}

sub fast_check_cpp {
    #This is very hobo
    my $file = shift @_;
    my $rt = shift @_;
    # If we do ANY type of string -> integer maaybe we have something
    if ($rt =~ /(simple_strtol|strict_strtol)/ && $rt =~ /unsigned/) {
	return 1;
    }
    # Deprecated min/max http://gcc.gnu.org/onlinedocs/gcc-4.0.1/gcc/Deprecated-Features.html
    if ($rt =~ /[\<\>]\?/) {
	return 1;
    }
    if ($rt =~ /memcpy\(\w+\,\s*0\s*,\s*0\)/) {
	return 1;
    }
}
