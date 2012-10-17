// find cases where a pointer is dereferenced and then compared to NULL
// this considers a very special case where the dereference is part of a
// declaration
//
// Confidence: High
// Copyright: (C) Gilles Muller, Julia Lawall, EMN, INRIA, DIKU.  GPLv2.
// URL: http://coccinelle.lip6.fr/rules/mini_null_ref.html
// Options:

@@
type T;
expression E;
identifier i,fld,f1;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
      when != f1(...,&E,...)
  if (E == NULL) { ... return ...; }
+ i = E->fld;
