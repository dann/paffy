package MyApp::Web::Model::Service;
use strict;
use warnings;
use base 'Catalyst::Model::MultiAdaptor';

__PACKAGE__->config(
    package   => 'MyApp::Service',
    config    => {
        'SomeClass' => {
            id => 1,
        },
        'AnotherClass' => {
            id => 2,
        }
    }
);

1;
