#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More 0.98;
use Test2::Tools::Exception qw/dies lives try_ok/;
use Data::Dump qw(dump);
use UK::Vehicle;
use Scalar::Util qw(looks_like_number);

# Test bad parameters
like(dies { $xero = UK::Vehicle->new(); }, qr/No VES API key/, "Handled no VES API key 1") or note($@);
like(dies { $xero = UK::Vehicle->new(timeout => 20); }, qr/No VES API key/, "Handled no VES API key 1") or note($@);

# Put something in here testing that API keys look right

# Test timeout looks like a number
like(dies { $xero = UK::Vehicle->new(timeout => "blah"); }, qr/Timeout value invalid/, "Handled weird timeout value") or note($@);

# And if it's all valid we should live
try_ok(lives { $xero = UK::Vehicle->new(ves_api_key => "KEY", timeout => 20); }, "Valid constructor with timeout lives") or note($@);
try_ok(lives { $xero = UK::Vehicle->new(ves_api_key => "KEY"); }, "Valid constructor without timeout lives") or note($@);

done_testing;
