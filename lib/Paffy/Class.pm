package Paffy::Class;
use Moose;

BEGIN {
    extends qw(Paffy::Component);
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;

__END__
