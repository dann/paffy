package Paffy::ORM::DBIx::Class::ResultSet;
use base qw(DBIx::Class::ResultSet);

sub find_cached {
    my ( $self, $cond, $attrs ) = @_;
    $attrs = {} unless $attrs;
    return $self->find( $cond, { %$attrs, cached => [qw(id)] } );
}

1;

__END__
