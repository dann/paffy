package Paffy::ConfigLoader;
use Moose;
use Paffy::Utils;
use Config::Any;
use File::Spec;

has 'prefix' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'extension' => (
    is      => 'rw',
    isa     => 'Str',
    default => sub {'yml'},
);

no Moose;

sub load {
    my $self  = shift;
    my @files = $self->find_files;
    my $cfg   = Config::Any->load_files(
        {   files   => \@files,
            use_ext => 1,
        }
    );

    my $config       = {};
    my $config_local = {};
    my $local_suffix = $self->get_config_local_suffix;
    for (@$cfg) {

        if ( ( keys %$_ )[0] =~ m{ $local_suffix \. }xms ) {
            $config_local = $_->{ ( keys %{$_} )[0] };
        }
        else {
            $config = { %{ $_->{ ( keys %{$_} )[0] } }, %{$config}, };
        }
    }

    $config = { %{$config}, %{$config_local}, };
    return $config;
}

sub local_file {
    my $self = shift;
    return File::Spec->catfile( $self->get_config_dir_path,
        $self->prefix . '_' . $self->get_config_local_suffix );
}

sub find_files {
    my $self = shift;
    my ( $path, $extension ) = $self->get_config_path;
    my $suffix     = $self->get_config_local_suffix;
    my @extensions = @{ Config::Any->extensions };

    my @files;
    if ($extension) {
        next unless grep { $_ eq $extension } @extensions;
        ( my $local = $path ) =~ s{\.$extension}{_$suffix.$extension};
        push @files, $path, $local;
    }
    else {
        @files = map { ( "$path.$_", "${path}_${suffix}.$_" ) } @extensions;
    }

    return @files;
}

sub get_config_dir_path {
    my $self = shift;
    my $home = Paffy::Utils::home;
    return File::Spec->catfile( $home, 'conf',
        $self->prefix . "." . $self->extension );

}

sub get_config_path {
    my $self = shift;
    my $path = $self->get_config_dir_path;
    return ( $path, $self->extension );
}

# FIXME
sub get_config_local_suffix {
    my $self = shift;
    # FIXME suffix should be fixed 
    my $suffix
        = Paffy::Utils::env_value( $self->prefix, 'CONFIG_LOCAL_SUFFIX' )
        || "local";
    return $suffix;
}

__PACKAGE__->meta->make_immutable;

1;

__END__
