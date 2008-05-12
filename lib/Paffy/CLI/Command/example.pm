package Paffy::CLI::Command::example;
use Moose;
extends qw(Paffy::CLI::Command);

has open => (
    isa           => "Str",
    is            => "rw",
    cmd_aliases   => "X",
    documentation => "open option",
);

sub run {
    my ( $self, $opt, $args ) = @_;
    print $self->open;
}

1;

__END__
