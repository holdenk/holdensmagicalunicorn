package Unicorn::Cpp;
use strict;
use File::Basename;
use File::Slurp qw (slurp);

my $spatchexec = "./bin/cpp_spatch";
my $spatchdir = "./cpp/spatches";

sub check_cpp {
    my $file = shift @_;
    my $rt = shift @_;
    return fast_check_cpp($file,$rt);
}

sub fix_cpp {
    my $file = shift @_;
    #Run the C++ spatches
    opendir (my $spatch_files, "$spatchdir") || "can't opendir $!\n";
    while (my $spatch_file = readdir($spatch_files)) {
	chomp ($spatch_file);
	if (-f $spatchdir."/".$spatch_file && $spatch_file =~ /\.cocci$/) {
	    print "running $spatchexec -c++ --in-place --sp-file $spatchdir/$spatch_file $file\n";
	    print "got:\n";
	    print `$spatchexec -c++ --in-place --sp-file $spatchdir/$spatch_file $file`;
	}
    }
    closedir($spatch_files);
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
    if ($rt =~ /memcpy\(\w+\,\s*(0|NULL)\s*,\s*0\)/) {
	return 1;
    }
}

use base 'Exporter';
our @EXPORT = qw{check_cpp fix_cpp};

1;
