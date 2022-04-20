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
use Config::Tiny;

my $ves_test_url = "https://uat.driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles";

my $tool;
$tool = UK::Vehicle->new(ves_api_key => "KEY");

SKIP: {
	skip ("active API tests; no config found in ./t/config/test_config.ini") unless -e './t/config/test_config.ini' ;
	note(" --- Running authentication tests - loading config ./t/config/test_config.ini");
}

done_testing;
