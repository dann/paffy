package Paffy::Cache;
use Moose;
BEGIN {
    extends qw(CHI Paffy::Class);
}

__PACKAGE__->meta->make_immutable;

1;
