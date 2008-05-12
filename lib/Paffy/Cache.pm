package Paffy::Cache;
use CHI;
use Moose;

has 'cache' => (
    is      => 'rw',
    handles => [
        qw(
            get set compute remove expire expire_if get_expires_at
            get_object clear get_keys is_empty purge get_namespaces
            get_multi_arrayref get_multi_hashref set_multi remove_multi dump_as_hash
        )
    ],
);

no Moose;

__PACKAGE__->meta->make_immutable;

1;
