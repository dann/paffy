#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use Paffy::JobQueue::Client::Async;
use Paffy::JobQueue::Task::Echo;
use Paffy::JobQueue::Task::Sleep;

my $client  = Paffy::JobQueue::Client::Async->new;

main();

sub main {
    add_tasks();
    $client->run
}

sub add_tasks {
    add_echo_task();
    add_sleep_task();
}

sub add_echo_task {
    my $echo_task = Paffy::JobQueue::Task::Echo->new;
    my $args = +{num =>1}; 
    $client->add_task( task => $echo_task, args => $args );
}

sub add_sleep_task {
    my $sleep_task = Paffy::JobQueue::Task::Sleep->new;
    $client->add_task( task => $sleep_task );
}

