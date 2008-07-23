use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::CIL',
    dist_version        => '0.5.1',
    requires => {
    },
    script_files        => [ 'bin/cil' ],
);

$builder->create_build_script();


