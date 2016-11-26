package IdShorts::App;

use strict;
use warnings;

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

    my $plugin  = MT->component('idshorts');
    my $blog_id = $app->param('blog_id') || $ENV{'BLOG_ID'};

    require MT::Entry;

    # It could be an entry id
    my $e;
    if ( $identifier =~ /^[\d]+$/ ) {
        $e = MT::Entry->load($identifier);
    }
    unless ($e) {
        #MT->log("checking meta: id_shorts_path for $identifier");

        # Or it could be a path or custom code
        my @meta_entries
            = MT::Entry->search_by_meta( 'id_shorts_path', $identifier, {},
            { blog_id => $app->{blog_id} || '*' } );
        $e = $meta_entries[0];
    }
    unless ($e) {

        # Or it could be a bad code
        $app->response_code("404");
        $app->response_message("Not Found");

        # Check if the BLOG_ID environment variable was set. If it was, we
        # want to try to load a custom 404 page at the blog level. If none at
        # the blog level, look at the system level.
        my $custom_404_id = $blog_id
            ? $plugin->get_config_value('custom_404_blog', "blog:$blog_id")
            : $plugin->get_config_value('custom_404');

        # If Clean Sweep is installed, hand over to it so that any redirects
        # can be checked for.
        if ( $app->component('CleanSweep') ) {
            $app->param('blog_id', $blog_id)
                if $blog_id;
            require CleanSweep::CMS;
            CleanSweep::CMS::report( $app );
        }

        if ($custom_404_id) {
            my $custom_404_page = MT->model('page')->load($custom_404_id)
                or die $app->log({
                        level   => $app->model('log')->ERROR(),
                        message => 'ID Shorts: Page ID ' . $custom_404_id
                            . ' could not be found.',
                        blog_id => $blog_id,
                    });

            my $file      = $custom_404_page->archive_file;
            my $arch_root = $custom_404_page->blog->site_path;

            use File::Spec;
            $file = File::Spec->catfile( $arch_root, $file );
            if ($file && -f $file) {
                open( my $custom_404, '<', $file )
                    or die "Could not open the error document! ($!)";
                my @lines;
                while (<$custom_404>) {
                    push @lines, $_;
                }
                return $app->response_content( join "\n", @lines );
            }
            else {
                return $app->error('Object not found.');
            }
        }
        return $app->error('Object not found.');
    }

    $app->{__entry} = $e;

    require MT::Util;
    my $link = MT::Util::strip_index( $e->permalink, $e->blog );

    # Add the Google `utm_medium` query parameter if requested.
    $blog_id = $e->blog_id
        if !$blog_id;
    $link .= '?utm_source=' . $identifier .'&utm_medium=go'
        if $plugin->get_config_value('append_query_param', "blog:$blog_id");

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
