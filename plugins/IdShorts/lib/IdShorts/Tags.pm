
package IdShorts::Tags;

use strict;
use warnings;

sub short_url {
    my ( $ctx, $args, $cond ) = @_;
    my $vars    = $ctx->{__stash}{vars} ||= {};
    
    my $e = $ctx->stash('entry') or return $ctx->_no_entry_error();

    require IdShorts::Util;
    return IdShorts::Util->short_url_for($e);
}



1;
