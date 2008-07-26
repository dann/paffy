use strict;
use warnings;
use lib 'lib';
use Paffy::JobQueue::Workers;

my $workers = Paffy::JobQueue::Workers->new;
$workers->run;
