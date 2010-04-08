
use lib qw( t/lib lib extlib );

use strict;
use warnings;

use MT::Test;
use Test::More tests => 5;

require MT;
ok( MT->component('idshorts'), "Plugin loaded successfully" );

require_ok('IdShorts::App');
require_ok('IdShorts::CMS');
require_ok('IdShorts::Util');
require_ok('IdShorts::Tags');

1;
