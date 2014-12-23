use 5.008001; use strict; use warnings; use utf8;

use lib 'inc';
use ExtUtils::MakeMaker;
use Inline::Module;

WriteMakefile(
  NAME => 'Alt::Acme::Math::XS::EUMM',
  VERSION => '0.0.13',
  ABSTRACT => 'Math is HARD (faster!)',
  AUTHOR => 'Ingy döt Net <ingy@cpan.org>',
  LICENSE => 'perl',
  MIN_PERL_VERSION => '5.008001',
  test => { TESTS => 't/*.t' },
  META_MERGE => {
    'meta-spec' => { version => 2 },
    prereqs => {
        develop => {
          requires => {
            'Inline::CPP'    => '0.69',
            'Inline::Module' => '0.27',
        },
      },
    },
    no_index => {
      directory => [
        'inc',
        'lib/Acme',
      ],
    },
  },
  postamble => {
    inline => {
      module => 'Acme::Math::XS',
    },
  },
);
