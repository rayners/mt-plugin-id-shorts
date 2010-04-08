
use lib qw( t/lib lib extlib );

use strict;
use warnings;

use MT::Test qw( :db :data );
use Test::More tests => 1;

require MT::Entry;
my $e = MT::Entry->load(1);

tmpl_out_like( '<mt:entryshorturl>', {}, { entry => $e },
    qr!^http://narnia\.na/nana/1$! );
1;
