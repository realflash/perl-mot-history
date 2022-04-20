#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More 0.98;
use Test2::Tools::Exception qw/dies lives try_ok/;
use Data::Dump qw(dump);
use UK::Vehicle;
use Scalar::Util qw(looks_like_number);
use Test::HTTP::MockServer::Once;

my $tool;
$tool = UK::Vehicle->new(ves_api_key => "KEY");



done_testing;
