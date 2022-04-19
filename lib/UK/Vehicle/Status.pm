package UK::Vehicle::Status;

use 5.030000;
use strict;
use warnings;


1;
__END__

=head1 SEE ALSO

See L<UK::Vehicle> for usage information.

=head1 METHODS

=over 3

=item is_mot_current()

   $status->is_mot_current();
   # returns 1 if there is a current, valid MOT. 0 otherwise.
   
This method looks at the property motExpiryDate, and then checks 
whether it is currently "valid". "Valid" means the following is true:
=over 6
=item * The last MoT test result was a pass
=item * The current time in the timezone Europe/London is not 
later than 23:59:59.000 on the expiry date.
=back
B<Yes>, as soon as vehicle fails an MoT, it no longer has a current 
valid MoT even if it not yet one year after the last pass, and you 
cannot legally drive it except under the limited circumstances provided
 for in the relevant law. B<Yes>, your MoT expires right at the very end
of the expiry date so you can drive it right up to midnight on that day.

=item is_tax_current()

   $status->is_tax_current();
   # returns 1 if the vehicle is taxed and can be on the road. 0 
   otherwise
   
This method looks at the property taxStatus, and then checks if it is 
"Taxed". Any status other than this, whether SORNd or untaxed, will 
return 0.

This method will croak if you have not yet called get().

=item is_sorn_declared()

	$status->is_sorn_declared();
	# returns 1 if a SORN has been made for the vehicle. 0 otherwise.

This method looks at the property taxStatus, and then checks if it is 
"SORN". Any status other than this, whether taxed or untaxed, will 
return 0.

This method will croak if you have not yet called get().
   
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
