
use lib qw( t/lib lib extlib );

use strict;
use warnings;

use MT::Test;
use Test::More tests => 2;

require MT;
ok(MT->component('idshorts'), "Plugin loaded successfully");

require_ok('IdShorts::App');

1;
