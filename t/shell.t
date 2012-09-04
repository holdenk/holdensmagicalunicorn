#Test the shell script thing
use Test::More tests => 3;
use Unicorn::Shell qw( fix_shell check_shell);

is (fix_shell("fake","#!/bin/bash\nif [-e foo -e bar]"), "#!/bin/bash\nif [-e foo] || [-e bar]", "Expands -e works");
is (check_shell("fake","#!/bin/bash\nif [-e foo -e bar]"), 1, "Expands -e works");
is (fix_shell("fake","#!/bin/bash\nif [-e foo -f bar]"), "#!/bin/bash\nif [-e foo -f bar]", "Does not expand -e / -f");

done_testing();