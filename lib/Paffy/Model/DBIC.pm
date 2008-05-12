package Paffy::Model::DBIC;
use Moose;
extends 'Paffy::Model';

has 'schema'       => ( is => 'rw' );
has 'slave_schema' => ( is => 'rw' );

sub model {
    my ( $self, $model_name ) = @_;
    my $name       = $self->_get_resultset_name($model_name);
    return $self->schema->resultset($name);
}

sub slave_model {
    my ( $self, $model_name ) = @_;
    my $name       = $self->_get_resultset_name($model_name);
    return $self->slave_schema->resultset($name);
}

sub _get_resultset_name {
    my ( $self, $model_name ) = @_;
    my ($name) = ( split( '::', $model_name ) )[-1];
    return $name;
}

1;

__END__
