use strict;
use warnings;
use lib 'lib';

{
    package MyApp::Model::Simple;
    use Moose;
    use base 'Paffy::Model';

    sub businessLogic: Before(Debug) {
        my ($self) = shift;
        print 'Hello';
    }
}

my $model =MyApp::Model::Simple->new;
$model->businessLogic();
