package Unicorn::Settings;
use File::Slurp qw (slurp);
use YAML::Any;
sub settings {
    $m = slurp("settings.yml");
    return Load($m);
}

use base 'Exporter';
our @EXPORT = qw{settings};

1;
