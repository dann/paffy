package Paffy::ORM::DBIx::Class::DeleteCache;
use strict;
use warnings;
use base qw(DBIx::Class Class::Data::Accessor);

__PACKAGE__->mk_classaccessors(qw/cache/);

sub update {
    my ( $class, $attrs ) = @_;
    my $cache = $class->cache;
    if ( $class->cache ) {
        my @columns
            = $class->can("cache_key_columns")
            ? $class->cache_key_columns
            : qw(id);
        for my $column (@columns) {
            my $cache_key = sprintf( "%s::%s::%s::%s",
                $class->result_source->storage->{__cache_prefix},
                join( "", map { ucfirst($_) } split( "_", $class->table ) ),
                $column,
                $class->$column );
            $cache->delete($cache_key);
        }
    }
    $class->next::method($attrs);
}

sub delete {
    my $class = shift;
    my $cache = $class->cache;
    if ($cache) {
        my @columns
            = $class->can("cache_key_columns")
            ? $class->cache_key_columns
            : qw(id);
        for my $column (@columns) {
            my $cache_key = sprintf( "%s::%s::%s::%s",
                $class->result_source->storage->{__cache_prefix},
                join( "", map { ucfirst($_) } split( "_", $class->table ) ),
                $column,
                $class->$column );
            $cache->delete($cache_key);
        }
    }
    $class->next::method(@_);
}

1;

__END__
