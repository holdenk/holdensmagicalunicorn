package Unicorn::PHP;
use strict;
use File::Basename;

my $spatchexec = "../pfff/spatch";
my $phpFunctionDir = "./php_functions/";

sub check_php {
    my $file = shift @_;
    my $rt = shift @_;
    #This is a bit of a quick search that might have a few false positives
    if ($rt =~ /(spliti\(.*+,.*+\)|\(\s*ip2long\(.*\)\s*\=\=\s*\-1\)\s*\)|mysql_db_query\(.*?\,.*?\))|hash_hmac/) {
        return 1;
    }
    return 0;
}
sub fix_php {
    my $file = shift @_;
    #Run the spatches
    #Check to see if the file needs us to add secure string cmp to it
    my $file_contents = ;
    if ($file_contents =~ /magicSecureStringCompare/) {
	$file_contents = addFunction($file_contents, $magicSecureStringCompare);
	
    }
}

sub addFunction {
    my $file_contents = shift @_;
    my $func = shift @_;
    if ($file_contents =~ /\<?/) {
	$file_contents =~ s/\<?/\<?\ninclude_once("$func\.php");/;
    } else {
	$file_contents = "include_once(\"$func\.php\");\n".$file_contents;
    }
    $file_path = dirname($path);
    `cp $phpFunctionDir.$func\.php $file_path`;
    `cd $file_path;git add $func\.php`;
}


use base 'Exporter';
our @EXPORT = qw{check_php fix_php};

1;
