# Gets top repos from  gitarchive.org
# Please run a bigtable query beforehand to make sure you have bq credentials setup
use strict;
use warnings;
use Slurp;

my $query = slurp("bigtablequery.bq");
my @languages = ("C++","C","OCAML","Ruby","Perl","PHP");
for my $language (@languages) {
    my $newquery = $query;
    $newquery =~ s/LANG/$language/g;
    $newquery =~ s/MYLIMIT/15000/g;
    print "running $newquery\n";
    my $hoboin;
    open($hoboin, "bq --project_id holdensmagicalunicorn --format csv query \"$newquery\"|");
    while (my $line = <$hoboin>) {
	my @murh = split(/\,/, $line);
	print $murh[0]."\n";
    }
}
