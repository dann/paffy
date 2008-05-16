package Paffy::CLI::Command;
use Moose;
BEGIN {
    extends qw(MooseX::App::Cmd::Command);
}

has 'config' => (
    is      => 'rw',
);

has 'schema' => (
    is      => 'rw',
);

__PACKAGE__->meta->make_immutable;

1;
