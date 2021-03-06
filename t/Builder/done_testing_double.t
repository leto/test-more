#!/usr/bin/perl -w

use strict;
use lib 't/lib';

use Test::Builder;
use TieOut;

my $tb = Test::Builder->create;

my $output = tie *FAKEOUT, "TieOut";
$tb->output(\*FAKEOUT);
$tb->failure_output(\*FAKEOUT);

{
    # Normalize test output
    local $ENV{HARNESS_ACTIVE};

    $tb->ok(1);
    $tb->ok(1);
    $tb->ok(1);

#line 24
    $tb->done_testing(3);
    $tb->done_testing;
    $tb->done_testing;
}

my $Test = Test::Builder->new;
$Test->plan( tests => 1 );
$Test->level(0);
$Test->is_eq($output->read, <<"END", "multiple done_testing");
ok 1
ok 2
ok 3
1..3
not ok 4 - done_testing() was already called at line 24
#   Failed test 'done_testing() was already called at line 24'
#   at $0 line 25.
not ok 5 - done_testing() was already called at line 24
#   Failed test 'done_testing() was already called at line 24'
#   at $0 line 26.
END
