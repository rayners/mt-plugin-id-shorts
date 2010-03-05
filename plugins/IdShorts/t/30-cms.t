
use lib qw( t/lib lib extlib );

use strict;
use warnings;

BEGIN {
    $ENV{MT_APP} = 'MT::App::CMS';
}

use MT::Test qw( :app :db :data );
use Test::More tests => 1;

require MT::Author;
my $a = MT::Author->load(1);

out_like(
    'MT::App::CMS',
    {   __test_user => $a,
        blog_id     => 1,
        id          => 1,
        __mode      => 'view',
        _type       => 'entry'
    },
    qr/<li class="short_clicks">/,
    "Found the li for short_clicks"
);

1;
