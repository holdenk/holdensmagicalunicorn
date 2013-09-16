
Backend Requirements: 
* Ocaml >= 4
* opam (if not installed might result in The constructor Tpat_construct expects 4 argument(s), but is applied here to 5 argument(s))
* Recent[ish] version of Perl 5 (was built against 5.14.2)
- Perl depdencies are brought in through the make file
* Recent[ish] version of Python (was built against 2.7.3)
* pfff [auto installed under 3rd party]
* Coccinelle [auto installed under 3rd party]
Fronted:
* django >= 1.4
* django-csvimport

A very simple github bot. Uses an accout of the same name. It provides spelling corrections for README files and other simple suggestions.
Requires pfff & php for the php code fixing to work.
The current method it works is find_targets[*].pl finds possible files on github that might have something we could do to them.
Then find_errors.pl will do a basic check
Then fix_pandas.pl does the "hard" work
Update settings.yml to have your credientals
See:
https://twitter.com/#!/HoldensUnicorn
https://github.com/holdensmagicalunicorn
https://github.com/holdensmagicalunicorn/holdensmagicalunicorn
http://twitter.com/#!/holdenkarau
http://www.holdenkarau.com/?q=magiclUnicorn