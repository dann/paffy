package Paffy::DBIx::Class::Storage::DBI::Cached;
use strict;
use base qw(DBIx::Class::Storage::DBI);
our $CACHE_EXPIRE = 60 * 60;

# set cache before use this class
# another solution? 
__PACKAGE__->mk_accessors(qw/cache/);

sub select_single {
    my $self = shift;
    my ($ident, $select, $condition, $attrs) = @_;
    if ($attrs->{cached}) {
        my $cache_key = $self->_check_cacheable($ident, $condition, $attrs->{cached});
        if($cache_key){
            if(my $cached_obj = $self->cache->get($cache_key)){
                if(ref $cached_obj eq "ARRAY"){
                    warn "[hit cache key] ". $cache_key;
                    return @$cached_obj;
                }
            }
            my ($rv, $sth, @bind) = $self->_select($ident, $select, $condition, $attrs);
            my @row = $sth->fetchrow_array;
            $sth->finish();
            $self->cache->set($cache_key, \@row, $CACHE_EXPIRE);
            warn "[set cache key] ". $cache_key;
            return @row;
        }
    }
    return $self->SUPER::select_single($ident, $select, $condition, $attrs);
}

sub _check_cacheable {
    my ($self, $ident, $condition, $cache_key_columns) = @_;
    my $table;
    return unless (
        ref $ident eq 'ARRAY' && scalar @$ident == 1 &&
            ref $ident->[0] eq 'HASH' && ($table = $ident->[0]->{me})
        );
    my @key_columns = @$cache_key_columns;
    return unless scalar @key_columns;
    my $cache_key;
    if(ref $condition eq 'HASH' && $condition->{'-and'} && ref $condition->{'-and'} eq 'ARRAY'){
        for my $key_col (@key_columns) {
            if (ref $key_col eq 'ARRAY') {
                my %key_set_hash = map { "me." . $_ => $_ } @$key_col;
                my %res;
                for my $cond (@{$condition->{'-and'}}){
                    next unless ref $cond eq 'HASH';
                    for my $key (keys %$cond){
                        my $k = delete $key_set_hash{$key};
                        $res{$k} = $cond->{$key} if defined $k;
                    }
                }
                unless (scalar keys %key_set_hash){
                    return sprintf(
                        "%s::%s::%s::%s",
                        $self->{__cache_prefix} || ref $self,
                        join("", map { ucfirst($_)} split("_", $table)),
                        join("+", keys %res),
                        join("+", values %res)
                    );
                }
            } else {
                for my $cond (@{$condition->{'-and'}}){
                    next unless ref $cond eq 'HASH';
                    for my $key (keys %$cond){
                        return sprintf(
                            "%s::%s::%s::%s",
                            $self->{__cache_prefix} || ref $self,
                            join("", map { ucfirst($_)} split("_", $table)),
                            $key_col,
                            $cond->{$key}
                        ) if $key eq "me.$key_col";
                    }
                }
            }
        }
    } elsif ( ref $condition eq 'ARRAY' && scalar @$condition == 1 && ref $condition->[0] eq 'HASH' ) {
        for my $key_col (@key_columns) {
            next if ref $key_col;
            return sprintf(
                "%s::%s::%s::%s",
                $self->{__cache_prefix} || ref $self,
                join("", map { ucfirst($_)} split("_", $table)),
                $key_col,
                $condition->[0]->{"me.$key_col"}
            ) if defined $condition->[0]->{"me.$key_col"};
        }
    }
    return;
}

1;

__END__
