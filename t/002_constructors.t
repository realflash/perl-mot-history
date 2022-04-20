#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More 0.98;
use Test2::Tools::Exception qw/dies lives try_ok/;
use Data::Dump qw(dump);
use UK::Vehicle;
use Scalar::Util qw(looks_like_number);

my $tool;
# Test bad parameters
like(dies { $tool = UK::Vehicle->new(); }, qr/parameter 'ves_api_key' must be supplied/, "Handled no VES API key 1") or note($@);
like(dies { $tool = UK::Vehicle->new(timeout => 20); }, qr/parameter 'ves_api_key' must be supplied/, "Handled no VES API key 1") or note($@);

# Put something in here testing that API keys look right

# Test timeout looks like a number
like(dies { $tool = UK::Vehicle->new(ves_api_key => "KEY", timeout => "blah"); }, qr/Timeout value must be a number/, "Handled weird timeout value") or note($@);

# And if it's all valid we should live
ok(lives { $tool = UK::Vehicle->new(ves_api_key => "KEY"); }, "Valid constructor without timeout lives") or note($@);
ok(lives { $tool = UK::Vehicle->new(ves_api_key => "KEY", timeout => 20); }, "Valid constructor with timeout lives") or note($@);
is($tool->timeout, 20, "Timeout successfully set");

done_testing;
