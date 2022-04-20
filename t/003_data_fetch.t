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

SKIP: {
	skip ("active API tests; no config found in ./t/config/test_config.ini") unless -e './t/config/test_config.ini' ;
	note(" --- Running authentication tests - loading config ./t/config/test_config.ini");

	# VALIDATE CONFIGURATION FILE
	ok(my $config =  Config::Tiny->read( './t/config/test_config.ini' ) , 'Load Config defined at ./t/config/test_config.ini }' );
	ok(defined($config->{'KEYS'}->{'VES_API_KEY'}), "Config file has a VES key in it");

	my $tool;
	$tool = UK::Vehicle->new(ves_api_key => $config->{'KEYS'}->{'VES_API_KEY'});
	my $status;
	ok($status = $tool->get("AA19AAA"));
	ok(defined($status));
	like($status->{'result'}, 1, "Valid car returns success code 1");
	like($status->{'message'}, "success", "Valid car returns success message");
}

done_testing;
