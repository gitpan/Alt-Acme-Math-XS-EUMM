use strict;
use warnings;

use 5.008001;

use ExtUtils::MakeMaker;

use lib 'inc'; use Inline::Module::MakeMaker;

WriteMakefile(
  NAME => 'Alt::Acme::Math::XS::EUMM',
  VERSION => '0.0.1',
  ABSTRACT => 'Math is HARD (faster)',
  AUTHOR => 'Ingy döt Net <ingy@cpan.org>',
  LICENSE => 'perl',
  MIN_PERL_VERSION => '5.008001',
  test => { TESTS => 't/*.t' },
);

FixMakefile(
  module => 'Acme::Math::XS',
);
