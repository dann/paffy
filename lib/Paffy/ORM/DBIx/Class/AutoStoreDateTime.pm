package Paffy::ORM::DBIx::Class::AutoStoreDateTime;
use strict;
use base qw(DBIx::Class);
use Paffy::Date;

sub new {
    my ( $class, $attrs ) = @_;
    $attrs->{created_on} = Paffy::Date->now
        if $class->has_column('created_on') && !length $attrs->{created_on};
    $attrs->{updated_on} = Paffy::Date->now
        if $class->has_column('updated_on') && !length $attrs->{updated_on};
    $class->next::method($attrs);
}

sub update {
    my ( $class, $attrs ) = @_;
    $attrs->{updated_on} = Paffy::Date->now
        if $class->has_column('updated_on');
    $class->next::method($attrs);
}

1;
