package Paffy::JobQueue::Worker;
use Moose;
use MooseX::Method;
use Gearman::Worker;
use Storable qw(thaw);

with 'Paffy::Role::Configurable';
has '+configfile' => ( default => '/etc/hoge' );

has 'job_servers' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { ['127.0.0.1'] },
);

has 'worker' => (
    is      => 'ro',
    default => sub {
        return Gearman::Worker->new;
    }
);

sub BUILD {
    my $self = shift;
    $self->worker->job_servers( @{ $self->job_servers } );
}

method register_function => named(
    task => { isa => 'Paffy::JobQueue::Task', required => 1 },
) => sub {
    my ( $self, $args ) = @_;
    my $task = $args->{task};

    $self->worker->register_function(
        $task->name, $task->timeout ,sub {
            my $job  = shift;
            my $arg = thaw( $job->arg );
            $task->execute( $arg );
        }
    );
};

sub run {
    my $self = shift;
    $self->worker->work while 1;
}

1;
