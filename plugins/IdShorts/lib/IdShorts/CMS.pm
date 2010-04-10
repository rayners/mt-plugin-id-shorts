
package IdShorts::CMS;

use strict;
use warnings;

sub edit_entry_source {
    my ( $cb, $app, $tmpl ) = @_;

    $$tmpl
        =~ s/(\Q<li class="pings-link">\E.*?<\/li>)/$1<li class="short_clicks"><__trans phrase="[quant,_1,shorts click,shorts clicks]" params="<\$mt:var name="id_shorts_clicks"\$>"> on <a href="<\$mt:var name="id_shorts_url"\$>"><\$mt:var name="id_shorts_url"\$><\/a><\/li>/;

    return 1;
}

sub cms_edit_entry {
    my ( $cb, $app, $id, $obj, $params ) = @_;

    require MT::Entry;
    return 1 if ( !$id );

    $params->{id_shorts_clicks} = $obj->id_shorts_clicks;

    require IdShorts::Util;
    $params->{id_shorts_url} = IdShorts::Util->short_url_for($obj);

    return 1;
}

1;
