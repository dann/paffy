package Paffy::ORM::DBIx::Class::ResultSet;
use base qw(DBIx::Class::ResultSet);

sub find {
    my ( $self, $cond, $attrs ) = @_;
    $attrs = {} unless $attrs;
    return $self->SUPER::find( $cond, { %$attrs, cached => [qw(id)] } );
}

1;

__END__
