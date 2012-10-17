// Deprecated min/max http://gcc.gnu.org/onlinedocs/gcc-4.0.1/gcc/Deprecated-Features.html
// Only works if "algorithm" is allready included
@i@
@@

#include <algorithm>
@depends on i@
expression x,y
@@
-x >? y
+std::max(x,y)
@depends on i@
expression x,y
@@
-x <? y
+std::min(x,y)