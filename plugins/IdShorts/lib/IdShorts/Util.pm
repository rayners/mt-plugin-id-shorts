
package IdShorts::Util;

use strict;
use warnings;

sub short_url_for {
    my ( $class, $entry ) = @_;

    require MT;
    my $p = MT->component('idshorts');

    my $url_template
        = $p->get_config_value( 'url_template', 'blog:' . $entry->blog_id );

    return if ( !$url_template );

    require MT::Template::Context;
    my $ctx = MT::Template::Context->new;
    $ctx->stash( 'entry',   $entry );
    $ctx->stash( 'blog',    $entry->blog );
    $ctx->stash( 'blog_id', $entry->blog_id );

    require MT::Builder;
    my $builder = MT::Builder->new;
    my $tokens = $builder->compile( $ctx, $url_template );

    my $out = $builder->build( $ctx, $tokens );

    return $out;
}

1;
