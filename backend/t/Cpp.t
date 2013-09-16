#Test the C++ script thing
#Note: we don't check to make sure things still compile/run since we
#are updating deprecated thigns that probably don't compile on mondern GCC anyways
#and I'm lazy.
use Test::More tests => 2;
use File::Temp;
use Unicorn::Cpp qw(fix_cpp check_cpp);
use File::Slurp qw (slurp);
use strict;

my $tempdir = File::Temp->newdir();
my $dirname = $tempdir->dirname;
print "temp dir $dirname\n";
`cp -af t/cpp_input $dirname/`;
`cp -af t/cpp_expected $dirname/`;
`cp -af t/cpp_input $dirname/cpp_output`;
opendir (my $cpp_input_files, "$dirname/cpp_input") || "can't opendir $!";
while (my $file = readdir($cpp_input_files)) {
    if (-f "$dirname/cpp_input/$file") {
	my $inputfile = "$dirname/cpp_output/$file";
	my $contents = slurp($inputfile);
	is(check_cpp($inputfile,$contents),1);
	fix_cpp($inputfile,$contents);
	is(slurp("$dirname/cpp_output/$file"),
	   slurp("$dirname/cpp_expected/$file"));
    }
}
closedir($cpp_input_files);
