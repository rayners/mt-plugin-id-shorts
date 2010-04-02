
package IdShorts::App;

use strict;
use base qw( MT::App );

sub id {'id_shorts'}

sub init {
    my $app = shift;
    $app->SUPER::init(@_);
    $app->{default_mode} = 'redirect';
    $app;
}

sub redirect_mode {
    my $app = shift;
    my $id = $app->path_info || $app->param('id');

    return $app->error('id required') if ( !$id );

    require MT::Entry;
    my $e = MT::Entry->load($id) or return $app->error('Unknown entry');
    $app->{__entry} = $e;

    require MT::Util;
    my $link = MT::Util::strip_index( $e->permalink, $e->blog );
    return $app->redirect($link);
}

sub takedown {
    my $app = shift;
    my $e   = delete $app->{__entry};
    if ($e) {

        # link was successful
        # record it if they want
        my $plugin = MT->component('idshorts');
        if ($plugin->get_config_value(
                'track_clicks', 'blog:' . $e->blog_id
            )
            )
        {

            # blog has tracking turned on
            # so let's track it
            my $clicks = $e->id_shorts_clicks || 0;
            $e->id_shorts_clicks( $clicks + 1 );
            $e->meta_obj->save;
        }
    }

    $app->SUPER::takedown();
}

1;
