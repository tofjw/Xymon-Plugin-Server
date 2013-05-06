#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Xymon::Plugin::Server' ) || print "Bail out!\n";
}

diag( "Testing Xymon::Plugin::Server $Xymon::Plugin::Server::VERSION, Perl $], $^X" );
