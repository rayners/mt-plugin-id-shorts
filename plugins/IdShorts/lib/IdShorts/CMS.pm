
package IdShorts::CMS;

use strict;
use warnings;

sub edit_entry_source {
    my ( $cb, $app, $tmpl ) = @_;

    $$tmpl
        =~ s/(\Q<li class="pings-link">\E.*?<\/li>)/$1<li class="short_clicks"><__trans phrase="[quant,_1,shorts click,shorts clicks]" params="<\$mt:var name="id_shorts_clicks"\$>"><\/li>/;

    return 1;
}

sub edit_entry_param {
    my ( $cb, $app, $params, $tmpl ) = @_;

    return 1;
}

1;
