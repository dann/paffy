package Paffy::Service::DBIC;
use Moose;
use UNIVERSAL::require;

BEGIN {
    extends qw(Paffy::Service);
}

has '_db' => ( is => 'rw' );

no Moose;

sub model {
    my ( $self, $model_name ) = @_;
    if($model_name =~ /^DBIC::/) {
        return $self->_db->model($model_name);

    } elsif($model_name =~ /(.*)::Slave$/) {
        return $self->slave_model($1);

    } else {
        my $class_name = __PACKAGE__;
        $class_name->require;
        return $class_name->new;
    }
}

sub slave_model {
    my ( $self, $model_name ) = @_;
    $self->_db->slave_model($model_name);
}

__PACKAGE__->meta->make_immutable;

1;

__END__
