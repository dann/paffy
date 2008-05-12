package Paffy::Component;

use Moose;
use Paffy::Utils;

with 'Paffy::ClassData';

__PACKAGE__->mk_classdata($_) for qw/_config/;

around new => sub {
    my $orig = shift;
    my ( $self, $c ) = @_;

    # Temporary fix, some components does not pass context to constructor
    my $arguments = ( ref( $_[-1] ) eq 'HASH' ) ? $_[-1] : {};

    my $args =  $self->merge_config_hashes( $self->config, $arguments );
    return $self->$orig( $args );
};

sub config {
    my $self = shift;
    my $config_sub = $self->can('_config');
    my $config = $self->$config_sub() || {};
    if (@_) {
        my $newconfig = { %{@_ > 1 ? {@_} : $_[0]} };
        $self->_config(
            $self->merge_config_hashes( $config, $newconfig )
        );
    } else {
        # this is a bit of a kludge, required to make
        # __PACKAGE__->config->{foo} = 'bar';
        # work in a subclass. Calling the Class::Data::Inheritable setter
        # will create a new _config method in the current class if it's
        # currently inherited from the superclass. So, the can() call will
        # return a different subref in that case and that means we know to
        # copy and reset the value stored in the class data.

        $self->_config( $config );

        if ((my $config_sub_now = $self->can('_config')) ne $config_sub) {

            $config = $self->merge_config_hashes( $config, {} );
            $self->$config_sub_now( $config );
        }
    }
    return $config;
}

sub merge_config_hashes {
    my ( $self, $lefthash, $righthash ) = @_;

    return Paffy::Utils::merge_hashes( $lefthash, $righthash );
}

1;

__END__
