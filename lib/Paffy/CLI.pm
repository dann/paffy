package Paffy::CLI;
use Moose;

BEGIN {
    extends qw(MooseX::App::Cmd);
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
