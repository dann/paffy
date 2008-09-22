package Paffy::Utils;
use strict;
use warnings;

use File::Spec;
use Path::Class qw(file dir);
use Class::Inspector;
use Carp qw/croak/;

=head1 NAME

Paffy::Utils - The PAFFY Utils

=head1 SYNOPSIS

See L<Paffy>.

=head1 DESCRIPTION

=head1 METHODS

=head2 appprefix($class)

    MyApp::Foo becomes myapp_foo

=cut

sub appprefix {
    my $class = shift;
    $class =~ s/::/_/g;
    $class = lc($class);
    return $class;
}

=head2 class2env($class);

Returns the environment name for class.

    MyApp becomes MYAPP
    My::App becomes MY_APP

=cut

sub class2env {
    my $class = shift || '';
    $class =~ s/::/_/g;
    return uc($class);
}

=head2 home($class)

Returns home directory for given class.

=cut

sub home {
    my $class = shift;

    # make an $INC{ $key } style string from the class name
    ( my $file = "$class.pm" ) =~ s{::}{/}g;

    if ( my $inc_entry = $INC{$file} ) {
        {

            # look for an uninstalled Paffy app

            # find the @INC entry in which $file was found
            ( my $path = $inc_entry ) =~ s/$file$//;
            my $home = dir($path)->absolute->cleanup;

            # pop off /lib and /blib if they're there
            $home = $home->parent while $home =~ /b?lib$/;

            # only return the dir if it has a Makefile.PL or Build.PL
            if ( -f $home->file("Makefile.PL") or -f $home->file("Build.PL") )
            {

                # clean up relative path:
                # MyApp/script/.. -> MyApp

                my $dir;
                my @dir_list = $home->dir_list();
                while ( ( $dir = pop(@dir_list) ) && $dir eq '..' ) {
                    $home = dir($home)->parent->parent;
                }

                return $home->stringify;
            }
        }

        {

            # look for an installed Paffy app

            # trim the .pm off the thing ( Foo/Bar.pm -> Foo/Bar/ )
            ( my $path = $inc_entry ) =~ s/\.pm$//;
            my $home = dir($path)->absolute->cleanup;

            # return if if it's a valid directory
            return $home->stringify if -d $home;
        }
    }

    # we found nothing
    return 0;
}

=head2 prefix($class, $name);

Returns a prefixed action.

    MyApp::Controller::Foo::Bar, yada becomes foo/bar/yada

=cut

=head2 ensure_class_loaded($class_name, \%opts)

Loads the class unless it already has been loaded.

If $opts{ignore_loaded} is true always tries the require whether the package
already exists or not. Only pass this if you're either (a) sure you know the
file exists on disk or (b) have code to catch the file not found exception
that will result if it doesn't.

=cut

sub ensure_class_loaded {
    my $class = shift;
    my $opts  = shift;

    croak "Malformed class Name $class"
        if $class =~ m/(?:\b\:\b|\:{3,})/;

    croak "Malformed class Name $class"
        if $class =~ m/[^\w:]/;

    croak
        "ensure_class_loaded should be given a classname, not a filename ($class)"
        if $class =~ m/\.pm$/;

    return
        if !$opts->{ignore_loaded}
            && Class::Inspector->loaded($class)
    ;    # if a symbol entry exists we don't load again

 # this hack is so we don't overwrite $@ if the load did not generate an error
    my $error;
    {
        local $@;
        my $file = $class . '.pm';
        $file =~ s{::}{/}g;
        eval { CORE::require($file) };
        $error = $@;
    }

    die $error if $error;
    die "require $class was successful but the package is not defined"
        unless Class::Inspector->loaded($class);

    return 1;
}

=head2 merge_hashes($hashref, $hashref)

Base code to recursively merge two hashes together with right-hand precedence.

=cut

sub merge_hashes {
    my ( $lefthash, $righthash ) = @_;

    return $lefthash unless defined $righthash;

    my %merged = %$lefthash;
    for my $key ( keys %$righthash ) {
        my $right_ref = ( ref $righthash->{$key} || '' ) eq 'HASH';
        my $left_ref
            = ( ( exists $lefthash->{$key} && ref $lefthash->{$key} ) || '' )
            eq 'HASH';
        if ( $right_ref and $left_ref ) {
            $merged{$key}
                = merge_hashes( $lefthash->{$key}, $righthash->{$key} );
        }
        else {
            $merged{$key} = $righthash->{$key};
        }
    }

    return \%merged;
}

sub path_to {
    my (@path) = @_;
    my $path = dir( &home, @path );
    if ( -d $path ) {
        return $path;
    }
    else {
        return file( &home, @path );
    }
}

sub env_value {
    my ( $class, $key ) = @_;

    $key = uc($key);
    my @prefixes = ( class2env($class), 'CATALYST' );

    for my $prefix (@prefixes) {
        if ( defined( my $value = $ENV{"${prefix}_${key}"} ) ) {
            return $value;
        }
    }

    return;
}

1;

__END__
