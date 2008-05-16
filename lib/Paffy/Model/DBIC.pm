package Paffy::Model::DBIC;
use Moose;
BEGIN {
    extends qw(Paffy::Model);
}

with 'Paffy::Role::Model::DBIC';

__PACKAGE__->meta->make_immutable;

1;

__END__
