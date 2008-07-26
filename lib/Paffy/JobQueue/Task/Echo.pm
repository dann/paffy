package Paffy::JobQueue::Task::Echo;
use Moose;
use Data::Dumper;

extends 'Paffy::JobQueue::Task';

sub execute {
    my ($self, $args) = @_;
    print "Echo command executed:";
    print Dumper $args;
    print "\n";
}

sub on_complete {
    print "completed\n";
}

sub on_fail {
    print "fail\n";
}

1;
