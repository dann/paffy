package Paffy::Class;
use attributes();
use Moose;
use base qw/Paffy::Component Paffy::AttrContainer/;

no Moose;

__PACKAGE__->meta->make_immutable();

1;

__END__
