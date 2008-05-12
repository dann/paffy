package Paffy::Class;

use Moose;
extends qw/Paffy::Component Paffy::AttrContainer/;

no Moose;
__PACKAGE__->meta->make_immutable();

1;

__END__
