package Paffy::Service::DBIC;
use Moose;

BEGIN {
    extends qw(Paffy::Service);
}
has '_db' => ( is => 'rw' );

sub model {
    my ( $self, $model_name ) = @_;
    $self->_db->model($model_name);
}

sub slave_model {
    my ( $self, $model_name ) = @_;
    $self->_db->slave_model($model_name);
}

__PACKAGE__->meta->make_immutable;

1;

__END__
