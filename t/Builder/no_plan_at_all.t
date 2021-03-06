#!/usr/bin/perl -w

# Test what happens when no plan is delcared and done_testing() is not seen

use strict;
use lib 't/lib';

use Test::Builder;
use TieOut;

my $Test = Test::Builder->new;
$Test->level(0);
$Test->plan( tests => 1 );

my $tb = Test::Builder->create;

my $output;
{
    $output = tie *OUT, "TieOut";

    $tb->level(0);
    $tb->output(*OUT);
    $tb->failure_output(*OUT);

    $tb->ok(1, "just a test");
    $tb->ok(1, "  and another");
    $tb->_ending;
}

$Test->is_eq($output->read, <<'END', "proper behavior when no plan is seen");
ok 1 - just a test
ok 2 -   and another
# Tests were run but no plan was declared and done_testing() was not seen.
END
