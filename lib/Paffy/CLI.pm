package Paffy::CLI;
use Moose;
extends qw(MooseX::App::Cmd Paffy::Class);

__PACKAGE__->meta->make_immutable;

1;
