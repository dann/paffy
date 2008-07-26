package Paffy::JobQueue::Client;
# TODO: Rename to Paffy::JobQueue::Gearman::Client ?

use Moose;
use MooseX::Method;
use Gearman::Client;
use Storable qw( freeze );

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
        my $client = Gearman::Client->new;
        $client;
    }
);

sub BUILD {
    my $self = shift;
    $self->setup;
}

sub run {
    my $self = shift;

    # do nothing in this class.
    # this class has the same interface for Client::Async
    # TODO: Implement Common Moose Role for Client
}

sub setup {
    my $self = shift;
    $self->_setup_client;
}

sub _setup_client {
    my $self = shift;
    $self->client->set_job_servers( @{ $self->job_servers } );
}

method add_task => named(
    task => { isa => 'Paffy::JobQueue::Task', required => 1 },
    args => {
        isa     => 'HashRef',
        default => sub { +{} }
    },
) => sub {
    my ( $self, $args ) = @_;
    my $task = $args->{task};

    $self->client->dispatch_background(
        $task->name,
        \freeze( $args->{args} ),
        +{},
    );
};

1;
