package Paffy::JobQueue::Task;
use Moose;
use String::CamelCase qw(decamelize);

with 'Paffy::Role::Configurable';

has 'timeout' => (
    is => 'rw',
    isa => 'Int',
    default => 60,
);

has 'retry_count' => (
    is => 'rw',
    isa => 'Int',
    default => 0,
);

sub name {
    my $self = shift;
    my ($name) = decamelize(ref $self);
    $name = $self->prefix . $name;
    return $name;
}

sub prefix {
    if ($ENV{PAFFY_DEV}) {
        return 'dev-';
    } else {
        return '';
    }
}

sub execute {
    die 'Virtual Method';
}

sub on_error {
}

sub on_complete {
}

sub on_retry {
}

1;
