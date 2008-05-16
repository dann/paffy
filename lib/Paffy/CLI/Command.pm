package Paffy::CLI::Command;
use Moose;
BEGIN {
    extends qw(MooseX::App::Cmd::Command);
}

has 'config' => (
    is      => 'rw',
);

with 'Paffy::Role::Model::DBIC';

__PACKAGE__->meta->make_immutable;

1;
