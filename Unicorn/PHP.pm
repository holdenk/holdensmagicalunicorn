package Unicorn::PHP;
use strict;
use File::Basename;
use File::Slurp qw (slurp);

my $spatchexec = "spatch";
my $phpFunctionDir = "./php_functions/";
my $spatchdir = "php_spatches";

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
    opendir (my $spatch_files, "$spatchdir") || "can't opendir $!\n";
    while (my $spatch_file = readdir($spatch_files)) {
	chomp ($spatch_file);
	if (-f $spatchdir."/".$spatch_file && $spatch_file =~ /\.spatch$/) {
	    `$spatchexec --apply-patch -f $spatchdir/$spatch_file $file`;
	}
    }
    closedir($spatch_files);
    #Check to see if the file needs us to add secure string cmp to it
    my $file_contents = slurp($file);
    if ($file_contents =~ /magicSecureStringCompare/) {
	$file_contents = addFunction($file, $file_contents, "magicSecureStringCompare");
    }
    open (my $output, ">$file");
    print $output $file_contents;
    close($output);
}

sub addFunction {
    my $file = shift @_;
    my $file_contents = shift @_;
    my $func = shift @_;
    if ($file_contents =~ /\<\?/) {
	$file_contents =~ s/\<\?/\<?\ninclude_once("$func\.php");/;
    } else {
	$file_contents = "include_once(\"$func\.php\");\n".$file_contents;
    }
    my $file_path = dirname($file);
    `cp $phpFunctionDir$func\.php $file_path`;
    `cd $file_path;git add $func\.php`;
    return $file_contents;
}


use base 'Exporter';
our @EXPORT = qw{check_php fix_php};

1;
