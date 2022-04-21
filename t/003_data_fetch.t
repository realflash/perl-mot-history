#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More 0.98;
use Test2::Tools::Exception qw/dies lives try_ok/;
use Data::Dump qw(dump);
use UK::Vehicle;
use UK::Vehicle::Status;
use Scalar::Util qw(looks_like_number);
use Config::Tiny;

my $ves_test_url = "https://uat.driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles";

SKIP: {
	skip ("active API tests; no config found in ./t/config/test_config.ini") unless -e './t/config/test_config.ini' ;
	note(" --- Running authentication tests - loading config ./t/config/test_config.ini");

	# VALIDATE CONFIGURATION FILE
	ok(my $config =  Config::Tiny->read( './t/config/test_config.ini' ) , 'Load Config defined at ./t/config/test_config.ini }' );
	ok(defined($config->{'KEYS'}->{'VES_API_KEY'}), "Config file has a VES key in it");

	my $tool;
	$tool = UK::Vehicle->new(ves_api_key => $config->{'KEYS'}->{'VES_API_KEY'}, _use_uat => 0);
	my $status;

	TODO: 
	{
		todo_skip('these tests only work in UAT',1);
		# Simulated 400
		ok($status = $tool->get("ER19BAD"), "Get method doesn't croak when HTTP status code is 400");
		ok(defined($status), "Get method returns something when HTTP status code is 400");
		is(ref($status), "UK::Vehicle::Status", "Returns a UK::Vehicle::Status");
		is($status->result, 0, "Bad car returns success code 0");
		is($status->message, "400 Bad Request", "Invalid car returns error message");
		sleep 1;
	}

	# Get an unknown car
	ok($status = $tool->get("AA19AAB"), "Get method doesn't croak");
	ok(defined($status), "Get method returns something");
	is(ref($status), "UK::Vehicle::Status", "Returns a UK::Vehicle::Status");
	is($status->result, 0, "Valid car returns success code 0");
	is($status->message, "404 Not Found", "Valid car returns error message");
	sleep 1;
	
	# Get a valid car
	ok($status = $tool->get("AA19AAA"), "Get method doesn't croak");
	ok(defined($status), "Get method returns something");
	is(ref($status), "UK::Vehicle::Status", "Returns a UK::Vehicle::Status");
	is($status->result, 1, "Valid car returns success code 1");
	is($status->message, "success", "Valid car returns success message");
	dump $status;
	
	ok(looks_like_number($status->co2Emissions), "Emissions is a number");
	ok(length($status->colour) > 2, "Colour has some text");
}

done_testing;
