package Unicorn::Scala;
use strict;

# See predef.scala A bunch of 
my @deprecated_lowercase_types = qw( byte short char int long float double boolean unit );
# See Math.scala
my @minmax_deprecated_math = qw( BYTE SHORT INT CHAR LONG FLOAT DOUBLE);
my @precise_deprecated_math = qw( DOUBLE FLOAT );
sub check_scala {
    my $file = shift @_;
    my $txt = shift @_;
    #Unapplied methods v2.6
    if ($txt =~ /[\(,]\s*\&\w+\s*[,\)]/) {
	return 1;
    }
    #Deprecated in 2.8.0 replaced with productIterator
    if ($txt =~ /import\s*scala\.product/i &&
	$txt =~ /\w+\.productElements\(\)/) {
	return 1;
    }
    #Math.pow => scala.math.pow
    if ($txt =~ /Math.pow\(\w+\s*,\s*\w+\s*\)/) {
	return 1;
    }
    #Math.sqrt => scala.math.sqrt
    if ($txt =~ /Math.pow\(\w+\s*,\s*\w+\s*\)/) {
	return 1;
    }
    for my $type (@minmax_deprecated_math) {
	if ($txt =~ /Math.(MIN|MAX)\_$type/) {
	    return 1;
	}
    }
    for my $type (@precise_deprecated_math) {
	if ($txt =~ /Math.(MAX|MIN|NaN|EPS|NEG\_INF|POS\_INF)\_$type/) {
	    return 1;
	}
    }
}

1;
