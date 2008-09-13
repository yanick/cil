use Test::More;

eval "use File::Temp qw/ tempdir /; 1"
    or plan skip_all => 'module File::Temp required to run tests';

eval "use Test::Command; 1"
    or plan skip_all => 'module Test::Command required to run tests';

plan tests => 10;

# create temp directory

my $dir = tempdir( 'ciltestXXXX', CLEANUP => 1 );

chdir $dir or die;

# just plain 'cil init'

my $cmd = cil_cmd('init');

$cmd->exit_is_num( 0, 'cil init' );
$cmd->stdout_like( qr/initialised empty issue list inside/,
    'stdout message' );

ok -d 'issues', 'issues dir created';

# cil init --path <foo>

mkdir 'subdir';

$cmd = cil_cmd( 'init', '--path', 'subdir' );

$cmd->exit_is_num( 0, 'cil init --path <foo>' );
$cmd->stdout_like(qr#initialised empty issue list inside 'subdir/'#);
ok -d 'subdir/issues';

# cil init bare

chdir '..';
chdir( $dir = tempdir( 'ciltestXXXX', CLEANUP => 1 ) );

$cmd = cil_cmd( 'init', '--bare' );
$cmd->exit_is_num( 0, 'cil init --bare' );
$cmd->stdout_like( qr/initialised empty issue list inside/,
    'stdout message' );

ok -f '.cil', '.cil exists';

open my $cil_fh, '<', '.cil';
my $content = join '', <$cil_fh>;
is $content, '', '.cil is empty';

chdir '..';

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub cil_cmd {
    return Test::Command->new( cmd => [ $^X, '-I../lib', '../bin/cil', @_ ] );
}
