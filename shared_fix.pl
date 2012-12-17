use strict;
use warnings;

sub handle_files {
    print "Handling files\n";
    my @files = @_;
    my @handlers = (handle_group("Fixing typos in README",qr/\/README(\.txt|\.rtf|\.md|\.pm|\.m\w+)$/,\&check_common,\&fix_text),
                    handle_group("Fixing old PHP calls",qr/\.php$/,\&check_php,\&fix_php),
                    handle_group("Updating shell scripts",qr/\/\w(\.sh|\.bash|)$/,\&check_shell,\&fix_shell),
                    handle_group("Fixing deprecated django",qr/\.py$/,\&check_py,\&fix_py),
		    handle_group("Fixing c",qr/\.c$/,\&check_cpp,\&fix_cpp),
		    handle_group("Fixing c++",qr/\.cpp$/,\&check_cpp,\&fix_cpp),
		    handle_group("Fixing scala",qr/\.scala$/,\&check_scala,\&fix_scala),
                    handle_group_cmd("Fixing go formatting",qr/\.go$/,\&check_go,\&fix_go));
    my $i = 0;
    my @changes = ();
    while ($i < $#handlers+1) {
        my $r = $handlers[$i](@files);
        if ($r) {
            push @changes, $r;
        }
        $i++;
    }
    return @changes;
}
sub handle_group {
    my $git_message = shift @_;
    my $gate_regex = shift @_;
    my $gate_function = shift @_;
    my $fix_function = shift @_;
    return sub {
	print "Handling the $git_message group\n";
        my $changes = 0;
        my @files = @_;
        foreach my $file (@files) {
            if ($file !~ /\/\.git\// && $file =~ $gate_regex) {        
                open (my $in, "<", "$file") or die "Unable to open $file";
                my $t = do { local $/ = <$in> };
                close($in);
                #Is there a spelling mistake?
                if ($gate_function->($file, $t)) {
                    open (my $out, ">", "$file") or die "Unable to open $file";
                    print $out $fix_function->($file, $t);
                    close ($out);
                }                
            }
        }
        #Determine if we have made any difference
        `cd foo/*;git diff --exit-code`;
        if ($? != 0) {
	    print "Changes for $git_message\n";
            #Yup
            `cd foo/*;git commit -a -m \"$git_message.\";`;
            return $git_message;
        } else {
	    print "No changes for $git_message\n";
	    #Nope no changes
	    return 0;
	}
    }
}

sub handle_group_cmd {
    my $git_message = shift @_;
    my $gate_regex = shift @_;
    my $gate_function = shift @_;
    my $fix_function = shift @_;
    return sub {
        my $changes = 0;
        my @files = @_;
        foreach my $file (@files) {
            if ($file !~ /\/\.git\// && $file =~ $gate_regex) {        
                $fix_function->($file);
            }
        }
        #Determine if we have made any difference
        `cd foo/*;git diff --exit-code`;
        if ($? != 0) {
            #Yup
            `cd foo/*;git commit -a -m \"$git_message\";`;
            return 1;
        }
        #Nope no changes
        return 0;
    }
}

1;
