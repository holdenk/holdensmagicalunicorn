// simple/strict_stroul rather than simple/strict_strol should be used
// when the result should be unsigned
//
// Confidence: High
// Copyright: (C) Gilles Muller, Julia Lawall, EMN, INRIA, DIKU.  GPLv2.
// URL: http://coccinelle.lip6.fr/rules/simple.html
// Options:

@r1@
int e;
position p;
@@

e = simple_strtol@p(...)

@r2@
long e;
position p;
@@

e = simple_strtol@p(...)

@r3@
s32 e;
position p;
@@

e = simple_strtol@p(...)

@@
position p != {r1.p,r2.p,r3.p};
type T;
T e;
@@

e = 
- simple_strtol@p
+ simple_strtoul
  (...)

@s1@
int e;
position p;
@@

strict_strtol@p(...,&e)

@s2@
long e;
position p;
@@

strict_strtol@p(...,&e)

@s3@
s32 e;
position p;
@@

strict_strtol@p(...,&e)

@@
position p != {s1.p,s2.p,s3.p};
type T;
T e;
@@

- strict_strtol@p
+ strict_strtoul
  (...,&e)
