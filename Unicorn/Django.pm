package django;
use strict;

sub check_django_settings {
    my $rt = shift @_;
    if ($rt =~ /django/) {
	#Now days we want full names like django.db.backends.sqlite3
	if ($rt =~ /\'ENGINE\'\s*:\s*\'(sqlite3|mysql|postgresql|oracle)\'/) {
	    return 1;
	}
	#DATABASE_FOO has been replaced with
	#DATABASES = {'default':{ 'FOO':'BAZ'},...}
	if ($rt =~ /DATABASE\_(ENGINE|NAME|USER|PASSWORD|HOST|PORT)/) {
	    return 1;
	}
    }
    return 0;
}
sub fix_django_settings {
    my $rt = shift @_;
    if ($rt =~ /django/) {
	#Now days we want full names like django.db.backends.sqlite3
	if ($rt =~ /\'ENGINE\'\s*:\s*\'(sqlite3|mysql|postgresql|oracle)\'/) {
	    $rt =~ s/\'ENGINE\'\s*:\s*\'(sqlite3|mysql|postgresql|oracle)\'/\'ENGINE\':'django.db.backends.$1'/g;
	}
	#DATABASE_FOO has been replaced with
	#DATABASES = {'default':{ 'FOO':'BAZ'},...}
	if ($rt =~ /DATABASE\_(ENGINE|NAME|USER|PASSWORD|HOST|PORT)\s*\=\s*[\'\"]/) {
	    my @lines = split /\n/, $rt;
	    for (my $j = 0;$j < $#lines; ++$j) {
		#We want to grab all of the DATABASE_ lines sitting together
		my %shineys;
		if ($lines[$j] =~ /DATABASE\_(.*)/) {
		    for my ($k = $j; $k < $#lines && $lines[$k] =~ /DATABASE\_(.*?)\s*\=/ ; ++$k) {
			if ($lines[$k] =~ /DATABASES\_(.*?)\s*\=\s*(.*)/) {
			    $lines[$k] = "$1 : $2";
			}
		    }
		}
		
	    }
	    $rt = join($line,'\n');
	}
    }
    return $rt;
}

use base 'Exporter';
our @EXPORT = qw{check_django_settings fix_django_settings};

1;
