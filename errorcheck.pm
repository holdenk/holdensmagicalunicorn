package errorcheck;

sub check_php {
    my $rt = shift @_;
    if ($rt =~ /(spliti\(.*+,.*+\)|\(\s*ip2long\(.*\)\s*\=\=\s*\-1\)\s*\)|mysql_db_query\(.*?\,.*?\))/) {
        return 1;
    }
    return 0;
}
sub fix_php {
    my $rt = shift @_;
    return $rt;
}
sub fix_shell {
    my $rt = shift @_;
    return $rt;
}
sub check_shell {
    my $rt = shift @_;
    my @r = split(/\n/,$rt);
    #Is it a shell script
    if ($r[0] =~ /\#\!\/bin\/(ba|z|)sh/ || $r[0] =~ /\#\!\/bin\/env (ba|z|)sh/) {
        print "yes!\n";
        #Probably!
        #Handle with [-e foo -e bar]
        if ($rt =~ /\[\s*\-e\s*\w*?\s*\-e\w*?\s*\]/) {
            return 1;
        }
        #Double negative
        if ($rt =~ /\[\s*\!\-z\"\$\w*\"\]/) {
            return 1;
        }
        #switch to mkdir -p
        if ($rt =~ /\[\s*\!\s*\-d\s*\"\$?(\w*)\"\s*\]\s*\&\&\s*mkdir/) {
            my $fname = $1.$2;
            if ($rt =~ /mkdir $fname/) {
                return 1;
            }
        }
        #switch to rm -f
        if ($rt =~ /\[\s*\-f\s*\"\$?(\w*)\"\s*\]\s*\&\&\s*rm/) {
            my $fname = $1.$2;
            if ($rt =~ /rm $fname/) {
                return 1;
            }
        }
        #Check for bare vars in ifs
        if ($rt =~ /if\s*\[\s*\$\w+\s*\=\s*\"\w+\"\s*\\]/) {
            return 1;
        }
        #Check for cat pipe to grep
        if ($rt =~ /cat\s*\w+\s*\|\s*grep\s+[\w\"]+/) {
            return 1;
        }
    } else {
        return 0;
    }
    return 0;
}
sub check_py {
    my $rt = shift @_;
    if ($rt =~ /\'ENGINE\'\s*:\s*\'sqlite3\'/) {
        return 1;
    }
    return 0;
}
sub fix_py {
    my $rt = shift @_;
    return 1;
}
sub check_go {
    my $rt = shift @_;
    return 1;
}
sub fix_go {
    my $filename = shift @_;
    `gofix "$filename"`;
    return 1;
}
sub check_cpp {
}
sub fix_cpp {
    my $rt = shift @_;
    return $rt;
}

use base 'Exporter';
our @EXPORT = qw{check_php fix_php check_py fix_py check_go fix_go check_cpp fix_cpp check_shell fix_shell};

1;
