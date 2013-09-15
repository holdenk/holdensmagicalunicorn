#Test the php script thing
use Test::More tests => 4;
use File::Temp;
use Unicorn::PHP qw(fix_php check_php);
use File::Slurp qw (slurp);
use strict;

my $tempdir = File::Temp->newdir();
my $dirname = $tempdir->dirname;
print "temp dir $dirname\n";
`cp -af t/php_input $dirname/`;
`cp -af t/php_expected $dirname/`;
`mkdir -p $dirname/php_expected_evaluated`;
`mkdir -p $dirname/php_evaluated`;
`cp -af t/php_input $dirname/php_output`;
`cd $dirname/php_output; git init .;git add *.php; git commit -am "initial bits"`;
opendir (my $php_input_files, "$dirname/php_input") || "can't opendir $!";
while (my $file = readdir($php_input_files)) {
    if (-f "$dirname/php_input/$file") {
	my $inputfile = "$dirname/php_output/$file";
	my $contents = slurp($inputfile);
	`php $dirname/php_input/$file > $dirname/php_expected_evaluated/$file.out`;
	is(check_php($inputfile,$contents),1);
	fix_php($inputfile,$contents);
	`php $dirname/php_output/$file > $dirname/php_evaluated/$file.out`;
	is(slurp("$dirname/php_expected_evaluated/$file.out"),
	   slurp("$dirname/php_evaluated/$file.out"));
	is(slurp("$dirname/php_output/$file"),
	   slurp("$dirname/php_expected/$file"));
	#Make sure we git added the file
	my $gstatus = `cd $dirname/php_output;git status`;
	is($gstatus =~ /new file:\s*magicSecureStringCompare\.php/,1);
    }
}

closedir($php_input_files);
