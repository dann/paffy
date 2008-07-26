package Paffy::Role::Configurable;
use Moose::Role;
  
with 'MooseX::ConfigFromFile';
use Paffy::ConfigLoader;

sub get_config_from_file {
    my ($class, $file) = @_;
    my $options = Paffy::ConfigLoader->load($file);
    return $options;
}

1;
