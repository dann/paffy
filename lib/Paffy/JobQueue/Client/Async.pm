package Paffy::JobQueue::Client::Async;
# TODO: Change the class name

use Moose;
use MooseX::Method;
use Gearman::Client::Async;
use Gearman::Task;
use Storable qw( freeze );
use Danga::Socket;

with 'Paffy::Role::Configurable';
has '+configfile' => ( default => '/etc/hoge' );

has 'job_servers' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { ['127.0.0.1'] },
);

has 'client' => (
    is      => 'ro',
    default => sub {
        my $self   = shift;
        my $client = Gearman::Client::Async->new;
        $client;
    }
);

has 'tasks' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { [] },
);

sub BUILD {
    my $self = shift;
    $self->setup;
}

sub run {
    my $self = shift;
    $self->start_loop;
}

sub post_event_loop_checker {
    my $self = shift;
    return sub {
        for ( @{ $self->tasks } ) {
            return 1 unless $_->is_finished;
        }
        $_->close() for @{ $self->client->{job_servers} };
        return 0;
    }
}

sub setup {
    my $self = shift;

    $self->_setup_client;

    Danga::Socket->DebugLevel(3);
    Danga::Socket->SetLoopTimeout(250);

    #  TODO:
    # Danga::Socket->SetPostLoopCallback( $self->post_event_loop_checker );
    # FIXME: Danga::Socket->WatchedSockets is 1. Why?
}

sub _setup_client {
    my $self = shift;
    $self->client->set_job_servers( @{ $self->job_servers } );
}

#TODO: Should this class have this method? 
method add_task => named(
    task => { isa => 'Paffy::JobQueue::Task', required => 1 },
    args => { isa => 'HashRef', default=>sub{+{}} },
) => sub {
    my ( $self, $args ) = @_;
    my $task = $args->{task};

    Danga::Socket->AddTimer(
        0 => sub {
            my $gtask = Gearman::Task->new(
                $task->name,
                \freeze($args->{args}),
                {
                    timeout     => $task->timeout,
                    on_complete => sub { 
                        my $output = shift;
                        $task->on_complete($output),
                    },
                    on_fail     => sub { 
                        $task->on_fail;
                    },
                    on_retry    => sub { 
                        my $retry_count = shift;
                        $task->on_retry($retry_count); 
                    },
                }
            );
            $self->client->add_task($gtask);
            push @{ $self->tasks }, $gtask;
        },
    );
};

sub start_loop {
    my $self = shift;
    Danga::Socket->EventLoop();
}

1;
