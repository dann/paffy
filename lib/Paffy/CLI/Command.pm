package Paffy::CLI::Command;
use Moose;
BEGIN {
    extends qw(MooseX::App::Cmd::Command);
}

with 'Paffy::Role::Configurable';
no Moose;

__PACKAGE__->meta->make_immutable;

1;
