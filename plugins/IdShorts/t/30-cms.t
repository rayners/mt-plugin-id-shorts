
use lib qw( t/lib lib extlib );

use strict;
use warnings;

BEGIN {
    $ENV{MT_APP} = 'MT::App::CMS';
}

use MT::Test qw( :app :db :data );
use Test::More tests => 3;

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

out_like(
    'MT::App::CMS',
    {   __test_user => $a,
        blog_id     => 1,
        id          => 1,
        __mode      => 'view',
        _type       => 'entry'
    },
    qr/0 shorts clicks/,
    "Found the li for short_clicks"
);

require MT::Entry;
my $e = MT::Entry->load (1);
$e->id_shorts_clicks(1);
$e->meta_obj->save;

out_like(
    'MT::App::CMS',
    {   __test_user => $a,
        blog_id     => 1,
        id          => 1,
        __mode      => 'view',
        _type       => 'entry'
    },
    qr/1 shorts click/,
    "Found the li for short_clicks"
);

1;
