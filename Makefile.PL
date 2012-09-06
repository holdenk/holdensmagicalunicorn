use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile
   (
   'NAME'         => 'HoldensMagicalUnicorn',
   'AUTHOR'       => 'Holden Karau <holden@pigscanfly.ca>',
   'INSTALLDIRS'  => 'site',
   'PREREQ_PM'    =>
      {
	 # TODO (holden) : Maybe pick some version numbers
         'Exporter'      => 0,
	 'LWP::UserAgent'    => 0,
	 'Net::Twitter'  => 0,
	 'Bing::Search' =>  0,
	 'Text::SpellChecker' => 0,
	 'Pithub' => 0,
      },
   'linkext'      => { LINKTYPE => '' }, # no link needed
   'dist'         =>
      {
         'COMPRESS'  => 'gzip -9f',
         'SUFFIX'    => 'gz',
         'ZIP'       => '/usr/bin/zip',
         'ZIPFLAGS'  => '-rl',
      }
   );
