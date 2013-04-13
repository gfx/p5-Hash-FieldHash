package builder::MyBuilder;
use strict;
use warnings;
use warnings FATAL => qw(recursion);
use parent qw(Module::Build);

use File::Basename;
use Devel::PPPort;

my $xs_src = 'src';

sub new {
    my($class, %args) = @_;

    Devel::PPPort::WriteFile("$xs_src/ppport.h");

    my $so_prefix = $args{module_name};
    $so_prefix =~ s/::\w+$//;
    $so_prefix =~ s{::}{/}g;

    #$args{c_source} = $xs_src;
    $args{needs_compiler} = 1;
    $args{xs_files} = {
        map { $_ => './_xs_build/' . $_ } glob("$xs_src/*.xs")
    };

    $args{extra_compiler_flags} = ["-I$xs_src"];

    return $class->SUPER::new(%args);
}

sub _infer_xs_spec {
    my($self, $xs_file) = @_;

    my $spec = $self->SUPER::_infer_xs_spec($xs_file);

    $spec->{module_name} = $self->module_name;

    my @d = split /::/, $spec->{module_name};

    my $basename = pop @d;

    # NOTE:
    # They've been infered from the XS source file, but it's a bad idea!
    # That's because these names are used XSLoader, which
    # deduces filenames from the module name, not a XS file name.
    $spec->{archdir} = File::Spec->catfile(
        $self->blib, 'arch', 'auto',
        @d, $basename);

    $spec->{bs_file}    = File::Spec->catfile(
        $spec->{archdir},
        $basename . '.bs');

    $spec->{lib_file}    = File::Spec->catfile(
        $spec->{archdir},
        $basename . '.' . $self->{config}->get('dlext'));

    use Data::Dumper; print Dumper $spec;

    return $spec;
}

1;
