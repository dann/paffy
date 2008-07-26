#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use Paffy::JobQueue::Worker;
use Paffy::JobQueue::Task::Echo;

my $worker  = Paffy::JobQueue::Worker->new;
my $echo_task = Paffy::JobQueue::Task::Echo->new;
my $sleep_task = Paffy::JobQueue::Task::Echo->new;
$worker->register_function(task=>$echo_task);
$worker->run;
