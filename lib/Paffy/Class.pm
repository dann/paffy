package Paffy::Class;
use attributes();
use Moose;
BEGIN {
    extends qw(Paffy::Component Paffy::AttrContainer);
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;

__END__
