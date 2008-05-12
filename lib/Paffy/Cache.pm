package Paffy::Cache;
use CHI;
use Moose;

has 'cache' => (
    is => 'rw',
    handles => [ qw(fetch store remove clear get_keys get_namespaces) ],
);

no Moose;

__PACKAGE__->meta->make_immutable;

1;
