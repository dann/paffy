package Paffy::CLI::Command;
use Moose;
BEGIN {
    extends qw(MooseX::App::Cmd::Command);
}

with 'Paffy::Role::Model::DBIC';
with 'Paffy::Role::Configurable';

has +configfile ( default => '/etc/myapp.yaml' );

__PACKAGE__->meta->make_immutable;

1;
