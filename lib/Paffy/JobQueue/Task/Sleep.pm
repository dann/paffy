package Paffy::JobQueue::Task::Sleep;
use Moose;
extends 'Paffy::JobQueue::Task';

has '+timeout' => (
    default => 5,
);

sub execute {
    my ($self, $args) = @_;
    print $self->name . " before\n";
    sleep(500);
    print $self->name . "\n";
}

sub on_complete {
    print "completed\n";
}

sub on_fail {
    print "fail in Task::Sleep\n";
}

1;
