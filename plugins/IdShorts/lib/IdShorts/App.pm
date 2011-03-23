
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
    my $identifier = $app->path_info || $app->param('id');

    return $app->error('required') if ( !$identifier );

    require MT::Entry;
    # It could be an entry id
    my $e = MT::Entry->load($identifier);
    unless ($e) {
        # Or it could be a path or custom code
        my @meta_entries =
            MT::Entry->search_by_meta( 'id_shorts_path', $identifier, {}, { blog_id => $app->{blog_id} || '*' } );
        $e ||= $meta_entries[0];
    }
    unless ($e) {
        # Or it could be a bad code
        $app->response_code("404");
        $app->response_message("Not Found");
        return $app->error('Object not found.');
    }

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
        if ( $plugin->get_config_value( 'track_clicks', 'blog:' . $e->blog_id ) ) {

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
