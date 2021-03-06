#Test the shell script thing
use Test::More tests => 5;
use Unicorn::Shell qw( fix_shell check_shell);

is (fix_shell("fake","#!/bin/bash\nif [-e foo -e bar]"), "#!/bin/bash\nif [-e foo] || [-e bar]", "Expands -e works");
is (check_shell("fake","#!/bin/bash\nif [-e foo -e bar]"), 1, "Expands -e detects an error");
is (fix_shell("fake","#!/bin/bash\nif [-e foo -f bar]"), "#!/bin/bash\nif [-e foo -f bar]", "Does not expand -e / -f");
is (fix_shell("fake","#!/bin/bash\nif [!-z \"\$foo\"]"), "#!/bin/bash\nif [\"\$foo\"]", "Removes double negatives");
is (fix_shell("fake","#!/bin/bash\ncat foo|grep bar"), "#!/bin/bash\ngrep bar < foo", "Remove unecessary cat");

done_testing();