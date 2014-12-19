use strict; use warnings; use utf8; use 5.008001;

use lib 'inc';
use ExtUtils::MakeMaker;
use Inline::Module;

WriteMakefile(
  NAME => 'Alt::Acme::Math::XS::EUMM',
  VERSION => '0.0.11',
  ABSTRACT => 'Math is HARD (faster!)',
  AUTHOR => 'Ingy döt Net <ingy@cpan.org>',
  LICENSE => 'perl',
  MIN_PERL_VERSION => '5.008001',
  test => { TESTS => 't/*.t' },
  META_MERGE => { no_index => { directory => [ 'lib/Acme' ] }, },
  postamble => {
    inline => {
      module => 'Acme::Math::XS',
    },
  },
);
