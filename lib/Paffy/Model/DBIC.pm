package Paffy::Model::DBIC;
use Moose;
BEGIN {
    extends qw(Paffy::Model);
}

has 'schema'       => ( is => 'rw' );
has 'slave_schema' => ( is => 'rw' );

no Moose;

sub dbic {
    my ( $self, $model_name ) = @_;
    my $name = $self->_get_resultset_name($model_name);
    return $self->schema->resultset($name);
}

sub slave_model {
    my ( $self, $model_name ) = @_;
    my $name = $self->_get_resultset_name($model_name);
    return $self->slave_schema->resultset($name);
}

sub _get_resultset_name {
    my ( $self, $model_name ) = @_;
    my ($name) = ( split( '::', $model_name ) )[-1];
    return $name;
}

__PACKAGE__->meta->make_immutable;

1;

__END__
