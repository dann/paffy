package Paffy::CLI::Command;
use Moose;
BEGIN {
    extends qw(MooseX::App::Cmd::Command);
}

__PACKAGE__->meta->make_immutable;

1;
