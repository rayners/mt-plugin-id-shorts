
use lib qw( t/lib lib extlib plugins/IdShorts/lib );

use strict;
use warnings;

BEGIN {
    $ENV{MT_APP} = 'IdShorts::App';
}

use MT::Test qw( :app :db :data );
use Test::More tests => 27;

require MT::Entry;
my $e = MT::Entry->load(1);
my $location_str = 'Location: ' . $e->permalink;

ok( !$e->id_shorts_clicks, "No clicks recorded" );

out_like( 'IdShorts::App', { id => 1 },
    qr/$location_str/, "Got the right redirect link" );

$e->refresh;
ok( !$e->id_shorts_clicks, "Still no clicks recorded" );

my $p = MT->component('idshorts');
$p->set_config_value( 'track_clicks', 1, 'blog:1' );

out_like( 'IdShorts::App', { id => 1 },
    qr/$location_str/, "Got the right redirect link" );

$e->refresh;
is( $e->id_shorts_clicks, 1, "One click recorded" );

out_like( 'IdShorts::App', { id => 1 },
    qr/$location_str/, "Got the right redirect link" )
    for ( 1 .. 10 );

$e->refresh;
is( $e->id_shorts_clicks, 11, "Eleven clicks recorded" );

$p->set_config_value( 'track_clicks', 0, 'blog:1' );

out_like( 'IdShorts::App', { id => 1 },
    qr/$location_str/, "Got the right redirect link" )
    for ( 1 .. 10 );

$e->refresh;
is( $e->id_shorts_clicks, 11, "Still only eleven clicks recorded" );

1;
