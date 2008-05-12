package Paffy::AttrContainer;

use Moose;
with 'Paffy::ClassData';

__PACKAGE__->mk_classdata($_) for qw/_attr_cache _action_cache/;
__PACKAGE__->_attr_cache( {} );
__PACKAGE__->_action_cache( [] );

# note - see attributes(3pm)
sub MODIFY_CODE_ATTRIBUTES {
    my ( $class, $code, @attrs ) = @_;
    $class->_attr_cache( { %{ $class->_attr_cache }, $code => [@attrs] } );
    $class->_action_cache(
        [ @{ $class->_action_cache }, [ $code, [@attrs] ] ] );
    return ();
}

sub FETCH_CODE_ATTRIBUTES { $_[0]->_attr_cache->{ $_[1] } || () }

1;

__END__
