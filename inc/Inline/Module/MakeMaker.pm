use strict; use warnings;
package Inline::Module::MakeMaker;

use Exporter 'import';
use ExtUtils::MakeMaker();
use Carp;

our @EXPORT = qw(FixMakefile);

sub new {
    my $class = shift;
    return bless {@_}, $class;
}

sub FixMakefile {
    my $self = __PACKAGE__->new(@_);

    croak "'inc' must be in \@INC. Add 'use lib \"inc\";' to Makefile.PL.\n"
        unless grep /^inc$/, @INC;
    croak "FixMakefile requires 'module' argument.\n"
        unless $self->{module};

    $self->fix_makefile;
}

sub fix_makefile {
    my ($self) = @_;

    $self->set_default_args;
    $self->read_makefile;
    $self->fixup_makefile;
    $self->add_postamble;
    $self->write_makefile;
}

sub set_default_args {
    my ($self) = @_;

    $self->{module} = [ $self->{module} ] unless ref $self->{module};
    $self->{inline} ||= [ map "${_}::Inline", @{$self->{module}} ];
    $self->{inline} = [ $self->{inline} ] unless ref $self->{inline};
    $self->{ilsm} ||= 'Inline::C';
    $self->{ilsm} = [ $self->{ilsm} ] unless ref $self->{ilsm};
}

sub read_makefile {
    my ($self) = @_;

    open MF_IN, '<', 'Makefile'
        or croak "Can't open 'Makefile' for input:\n$!";
    $self->{makefile} = do {local $/; <MF_IN>};
    close MF_IN;
}

sub write_makefile {
    my ($self) = @_;

    my $makefile = $self->{makefile};
    open MF_OUT, '>', 'Makefile'
        or croak "Can't open 'Makefile' for output:\n$!";
    print MF_OUT $makefile;
    close MF_OUT;
}

sub fixup_makefile {
    my ($self) = @_;

    $self->{makefile} =~ s/^(distdir\s+):(\s+)/$1::$2/m;
    $self->{makefile} =~ s/^(pure_all\s+):(\s+)/$1::$2/m;
}

sub add_postamble {
    my ($self) = @_;

    my $inline_section = $self->make_distdir_section();

    $self->{makefile} .= <<"...";

# Inline::Module::MakeMaker is adding this section:

# --- MakeMaker Inline::Module sections:

$inline_section
...
}

sub make_distdir_section {
    my ($self) = @_;

    my $code_modules = $self->{module};
    my $inlined_modules = $self->{inline};
    my @included_modules = $self->included_modules();

    my $section = <<"...";
distdir ::
\t\$(NOECHO) \$(ABSPERLRUN) -MInline::Module=distdir -e 1 -- \$(DISTVNAME) @$inlined_modules -- @included_modules

pure_all ::
...

    for my $module (@$code_modules) {
        $section .=
            "\t\$(NOECHO) \$(ABSPERLRUN) -Iinc -Ilib -e 'use $module'\n";
    }
    $section .=
        "\t\$(NOECHO) \$(ABSPERLRUN) -Iinc -MInline::Module=fixblib -e 1";

    return $section;
}

sub include_module {
    my ($self) = @_;

    my $module = shift;
    eval "require $module; 1" or die $@;
    my $path = $module;
    $path =~ s!::!/!g;
    my $source_path = $INC{"$path.pm"}
        or die "Can't locate $path.pm in %INC";
    my $inc_path = "inc/$path.pm";
    my $inc_dir = $path;
    $inc_dir =~ s!(.*/).*!$1! or
        $inc_dir = '';
    $inc_dir = "inc/$inc_dir";
    return ("$path.pm", $inc_path, $inc_dir);
}

sub included_modules {
    my ($self) = @_;

    return (
        'Inline',
        'Inline::denter',
        @{$self->{ilsm}},
        'Inline::C::Parser::RegExp',
        'Inline::Module',
        'Inline::Module::MakeMaker',
    );
}

1;
