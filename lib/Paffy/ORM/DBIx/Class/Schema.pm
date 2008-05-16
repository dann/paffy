package Paffy::ORM::DBIx::Class::Schema;

use Moose;
BEGIN {
    extends qw(DBIx::Class::Schema);
}

# XXX
our $DEBUG = 1;

use MooseX::ClassAttribute;
use MyApp::ConfigLoader;
use Data::Dumper;
use Paffy::Cache;

# need to set default by subclass
class_has 'config' => ( 'is' => 'rw' );
class_has 'cache'  => ( 'is' => 'rw' );

sub master {
    my $class = shift;

    my $connect_info = $class->config->{'Model::DBIC'}{'connect_info'};
    my $schema       = $class->connect( @{$connect_info} );

    $schema->default_resultset_attributes(
        { cache_object => $class->Cache } );

    return $schema;
}

sub slave {
    my $class = shift;

    my $connect_info = $class->config->{'Model::DBIC::Slave'}{'connect_info'};
    my $schema       = $class->connect( @{$connect_info} );

    $schema->default_resultset_attributes(
        { cache_object => $class->cache } );
    return $schema;
}

sub connection {
    my ( $self, @info ) = @_;
    return $self if !@info && $self->storage;

    my $storage_class = $self->storage_class;
    eval "require ${storage_class};";
    $self->throw_exception(
     "No arguments to load_classes and couldn't load ${storage_class} ($@)"
    ) if $@;
    
    my $storage = $storage_class->new($self);
    # This call my cache function?
    # FIXME
    $storage->cache(Paffy::ORM::DBIx::Class::Schema->cache) if Paffy::ORM::DBIx::Class::Schema->cache;
    $storage->{__cache_prefix} = ref $self;
    $storage->connect_info( \@info );

    # FIXME
    $self->storage($storage);
    
    # XXX:
    $self->storage->debug(1) if $DEBUG;
    return $self;
}

sub storage_class {
    my $self = shift;
    my $storage_class;
    if(Paffy::ORM::DBIx::Class::Schema->cache) {
        $storage_class = 'DBIx::Class::Storage::DBI::Cached';
    } else {
        $storage_class = $self->storage_type;
        $storage_class = 'DBIx::Class::Storage'.$storage_class if $storage_class =~ m/^::/;
    }
    $storage_class;
}

# You can replace this text with custom content, and it will be preserved on regeneration
1;
