use inc::Module::Install;
name 'Paffy';
all_from 'lib/Paffy.pm';

requires 'Moose';
requires 'MooseX::Object::Pluggable';
requires 'MooseX::Types';
requires 'Scalar::Util';
requires 'MooseX::AttributeHelpers';
requires 'MooseX::App::Cmd';
requires 'File::Spec';
requires 'Path::Class';
requires 'Class::Inspector';
requires 'CHI';

build_requires 'Test::More';
build_requires 'Test::Base';
build_requires 'Test::Class';
use_test_base;
auto_include;
WriteAll;
