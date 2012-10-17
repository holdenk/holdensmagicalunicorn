// memcpy of zero bytes from NULL
// inspired by:
// http://www.daemonology.net/blog/2011-08-26-1265-dollars-of-tarsnap-bugs.html

@@
function memcpy;
identifier x;
@@
-memcpy(x, NULL, 0)
+