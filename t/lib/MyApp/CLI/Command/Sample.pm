package MyApp::CLI::Command::Sample;
use Moose;
BEGIN {
    extends qw(Paffy::CLI::Command);
}

=head1 NAME

MyApp::CLI::Command::example - example command

=cut


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
1

