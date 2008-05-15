package Paffy::ORM::DBIx::Class::Schema;
use strict;
use warnings;

use base 'DBIx::Class::Schema';

our $DEBUG = 1;
use Moose;
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
        { cache_object => $class->cache } );

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
    unless ( $self->storage ) {
        my $storage_class = 'DBIx::Class::Storage::DBI::Cached';
        eval "require ${storage_class};";
        $self->throw_exception("can't load ${storage_class} ($@)") if $@;

        # FIXME: CHI enabled cache 
        my $storage = $storage_class->new();
        # This call my cache function?
        $storage->cache(cache);
        $storage->{__cache_prefix} = ref $self;
        $storage->connect_info( \@info );
        $self->storage($storage);
    }
    $self->storage->debug(1) if $DEBUG;
    return $self;
}

# You can replace this text with custom content, and it will be preserved on regeneration
1;
