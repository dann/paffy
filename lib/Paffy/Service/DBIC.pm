package Paffy::Service::DBIC;
use Moose;

has 'db' => (is => 'rw');

sub model {
    my $self       = shift;
    my $model_name = shift;
    $self->db->model($model_name);
}

sub slave_model {
    my $self       = shift;
    my $model_name = shift;
    $self->db->slave_model($model_name);
}

__PACKAGE__->meta->make_immutable;

1;

__END__
