package errrorcheck;

use strict;

sub check_php {
    my $rt = shift @_;
    if ($rt =~ /(spliti\(.*+,.*+\)|\(\s*ip2long\(.*\)\s*\=\=\s*\-1\)\s*\)|mysql_db_query\(.*?\,.*?\))/) {
        return 1;
    }
    return 0;
}
sub check_shell {
    my $rt = shift @_;
    my @r = split(/\n/,$rt);
    #Is it a shell script
    if ($r[0] =~ /\#\!\/bin\/(ba|z|)sh/ || $r[0] =~ /\#\!\/bin\/env (ba|z|)sh/) {
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
sub check_go {
    my $rt = shift @_;
    #Check for = nil 
    if ($rt =~ /\w*\[\w*\]\s*\=\s*nil\s*$/) {
        return 1;
    } else {
        return 0;
    }
}
