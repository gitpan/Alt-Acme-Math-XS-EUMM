use strict;
use warnings;

use 5.008001;

use ExtUtils::MakeMaker;
WriteMakefile(
  NAME => 'Alt::Acme::Math::XS::EUMM',
  VERSION => '0.0.2',
  ABSTRACT => 'Math is HARD (faster)',
  AUTHOR => 'Ingy döt Net <ingy@cpan.org>',
  LICENSE => 'perl',
  MIN_PERL_VERSION => '5.008001',
  test => { TESTS => 't/*.t' },
  META_MERGE => { no_index => { directory => [ 'lib/Acme' ] }, },
);

use lib 'inc';
use Inline::Module::MakeMaker;
FixMakefile(
  module => 'Acme::Math::XS',
);
