package Paffy::CLI::Command::example;
use Moose;
BEGIN {
    extends qw(Paffy::CLI::Command);
}

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

=head1 NAME

Paffy::CLI::Command::example - example command

=cut

1;

__END__
