package Paffy::Model;
use Moose;

BEGIN {
    extends qw(Paffy::Class);
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;

__END__

