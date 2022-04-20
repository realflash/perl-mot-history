package UK::Vehicle;

use 5.030000;
use strict;
use warnings;
require UK::Vehicle::Status;
use LWP::UserAgent;
use subs 'timeout';
use Class::Tiny qw(ves_api_key _ua timeout);
use Carp;
use JSON;
use Try::Tiny;
use Scalar::Util qw(looks_like_number);

our $VERSION = '0.01';

sub BUILD
{	
	my ($self, $args) = @_;
	
	$self->_ua(LWP::UserAgent->new);
	$self->_ua->timeout(10);
	$self->_ua->env_proxy;
	
	croak "parameter 'ves_api_key' must be supplied to new" unless $self->ves_api_key;
	croak "VES API key is malformed" unless length($self->ves_api_key) > 1;				# TODO make more complicated
	if(defined($args->{'timeout'}))
	{
		croak "Timeout value must be a number in seconds" unless looks_like_number($args->{'timeout'});
		$self->timeout($args->{'timeout'});
	}
}

sub timeout
{
	my $self = shift;
	my $arg = shift;
    if ($arg) {
		$self->_ua->timeout($arg);
    }
	return $self->_ua->timeout;
}



1;
__END__

=head1 NAME

UK::Vehicle - Perl module to query the UK's Vehicle Enquiry Service API

=head1 SYNOPSIS

	use UK::Vehicle;
	my $tool  = new UK::Vehicle:(ves_api_key => '<your-api-key>');
	my $status = $tool->get('<vehicle-vrm>');
	$status->result; 	# 1 for success, 0 for failure
	$status->message;	# 'success' or an error message
	$status->is_mot_valid();
	$status->is_vehicle_taxed();
	etc..

=head1 DESCRIPTION

This module helps you query the Vehicle Enquiry Service API provided by 
the UK's DVLA. In order to use it you must have an API key, which you 
can apply for at L<here|https://register-for-ves.driver-vehicle-licensing.api.gov.uk/>

You will likely need a decent reason to have an API key. It takes days 
to get one so you may want to apply now. 

=head2 EXPORT

None by default.

=head1 CONSTRUCTORS

=over 3

=item new(ves_api_key => value)

=item new(ves_api_key => value, timeout => integer)

Create a new instance of this class, passing in the API key you wish to 
use. This argument is mandatory. Failure to set it upon creation will 
result in the method croaking.

Optionally also set the connect timeout in seconds. Default value is 10.  

=back

=head1 METHODS

=over 3

=item get(string)

   my $status = $tool->get("ZZ99ABC");
   $status->{'result'}; # 1 if success, 0 if not
   $status->{'message'}; # "success" if result was 1, error message if not

Query the API for the publicly-available information about a vehicle. 
Returns a hash ref:

	{
	  "result" => 1,
	  "message" => success,
	  "registrationNumber" => "WN67DSO",
	  "taxStatus" => "Untaxed",
	  "taxDueDate" => "2017-12-25",
	  "artEndDate" => "2007-12-25",
	  "motStatus" => "No details held by DVLA",
	  "motExpiryDate" => "2008-12-25",
	  "make" => "ROVER",
	  "monthOfFirstDvlaRegistration" => "2011-11",
	  "monthOfFirstRegistration" => "2012-12",
	  "yearOfManufacture" => 2004,
	  "engineCapacity" => 1796,
	  "co2Emissions" => 0,
	  "fuelType" => "PETROL",
	  "markedForExport" => true,
	  "colour" => "Blue",
	  "typeApproval" => "N1",
	  "wheelplan" => "NON STANDARD",
	  "revenueWeight" => 1640,
	  "realDrivingEmissions" => "1",
	  "dateOfLastV5CIssued" => "2016-12-25",
	  "euroStatus" => "Euro 5"
	}
   
You can access any of these pieces of data by referencing that value in 
the hash reference:

   print $result->{'model'};
   
Any spaces in the VRM you provide will be automatically removed. Lower
 case characters will be changed to upper case. If the
 VRM you provide contains weird characters, you will get 0 back and an
 appropriate message. Permitted characters are 0-9, a-z, A-Z.   

=item is_mot_current()
=item is_tax_current()
=item is_sorn_declared()

	See L<UK::Vehicle::Status>

=back

=head1 BUGS AND REQUESTS

Please report to L<the GitHub repository|https://https://github.com/realflash/perl-mot-history>

=head1 AUTHOR

Ian Gibbs, E<lt>igibbs@cpan.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2022 by Ian Gibbs

This library is free software; you can redistribute it and/or modify
it under the terms of the GNU GPL version 3.

=cut
