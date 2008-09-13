use Test::More;

eval "use File::Temp qw/ tempdir /; 1"
    or plan skip_all => 'module File::Temp required to run tests';

eval "use Test::Command; 1"
    or plan skip_all => 'module Test::Command required to run tests';

plan tests => 6;

# create temp directory

my $dir = tempdir( 'cilXXXX', CLEANUP => 1 );

chdir $dir or die;

Test::Command::exit_is_num( [ qw/ git init / ], 0, 'git init' );

cil_cmd( 'init' )->exit_is_num( 0, 'cil init' );

ok -d 'issues', 'issues dir created';

# create an issue

open my $issue_fh, '>', 'issues/i_cafebabe.cil';
print {$issue_fh} <DATA>;
close $issue_fh;

ok -e 'issues/i_cafebabe.cil', "issue cafebabe exists";

my $result = cil_cmd( 'list' );

$result->exit_is_num( 0, 'cil list' );
$result->stdout_like( qr/Ability to set Issue/, 'cil list displays issue' );


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub cil_cmd {
    return Test::Command->new(
        cmd => [ $^X, '-I../lib', '../bin/cil', @_ ] 
    );
}

__DATA__
Summary: Ability to set Issue Status' from the command line
Status: Finished
CreatedBy: Andrew Chilton <andychilton@gmail.com>
AssignedTo: Andrew Chilton <andychilton@gmail.com>
Label: Milestone-v0.2
Label: Release-v0.1.0
Label: Type-Enhancement
Comment: 792a4acf
Inserted: 2008-06-22T04:00:20
Updated: 2008-06-26T11:56:03

The ability to do something like the following would be good.

    $ cil status cafebabe Finished

would be rather cool.

