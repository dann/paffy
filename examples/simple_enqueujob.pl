#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use Paffy::JobQueue::Server;
use Paffy::JobQueue::Task::Echo;
use Paffy::JobQueue::Task::Sleep;
my $workers  = Paffy::JobQueue::Server->new;
my $echo_task = Paffy::JobQueue::Task::Echo->new;
my $args = +{num =>1}; 
$workers->add_task( task => $echo_task, args => $args );
my $sleep_task = Paffy::JobQueue::Task::Sleep->new;
$workers->add_task( task => $sleep_task );
$workers->run;
