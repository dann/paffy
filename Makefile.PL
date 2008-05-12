use inc::Module::Install;
name 'Paffy';
all_from 'lib/Paffy.pm';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
