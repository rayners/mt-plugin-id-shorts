
package IdShorts::CMS;

use strict;
use warnings;

sub edit_entry_source {
    my ( $cb, $app, $tmpl ) = @_;

    $$tmpl
        =~ s/(\Q<li class="pings-link">\E.*?<\/li>)/$1<li class="short_clicks"><__trans phrase="[quant,_1,shorts click,shorts clicks]" params="<\$mt:var name="id_shorts_clicks"\$>"> on <a href="<\$mt:var name="id_shorts_url"\$>"><\$mt:var name="id_shorts_url"\$><\/a><\/li>/;
    
    my $short_field = <<"FIELDHTML";
    <mtapp:setting
        id="id_shorts_path"
        label="Short URL Path"
        hint="Short URL or vanity URL path (some/vanity/path with no leading /)<br/>Defaults to the entry ID."
        show_hint="1">
            <input type="text" name="id_shorts_path" id="id_shorts_path" value="<mt:var name="id_shorts_path" />" />
        </mt:if>
    </mtapp:setting>
FIELDHTML
    
    $$tmpl =~ s/(<mtapp:setting.*?id="basename".*?<\/mtapp:setting>)/$1$short_field/xsm;
    # <input type="text" name="short_url_path" size="15">
    return 1;
}

sub cms_edit_entry {
    my ( $cb, $app, $id, $obj, $params ) = @_;

    require MT::Entry;
    return 1 if ( !$id );

    $params->{id_shorts_clicks} = $obj->id_shorts_clicks;
    $params->{id_shorts_path} = $obj->id_shorts_path || $obj->id;

    require IdShorts::Util;
    $params->{id_shorts_url} = IdShorts::Util->short_url_for($obj);

    return 1;
}

sub pre_save_entry {
    MT->log('pre_save_entry');
    my ($cb, $app, $obj, $original) = @_;
    MT->log($app->param('id_shorts_path'));
    if (my $path = $app->param('id_shorts_path')) {
        MT->log($path);
        $obj->id_shorts_path($path);
    }
    return 1;
}

1;

__END__

<div class="field field-left-label pkg " id="basename-field">
    <div class="field-inner">
        <div class="field-header">
            <label for="basename" id="basename-label">Basename</label>
        </div>
        <div class="field-content ">
            
                <input type="hidden" value="" id="basename_old" name="basename_old">
                <input type="text" onchange="setElementValue('basename', dirify(this.value))" value="" id="basename" name="basename" disabled="disabled">
            
            
                
                <a onclick="return toggleFile()" title="Unlock this entry’s output filename for editing" id="basename-lock" href="javascript:void(0);"><span>Unlock</span></a>
                
                <p style="display: none" id="basename-warning" class="alert-warning-inline">
                    <img width="9" height="9" alt="Warning" src="/~steve/mt-pro/mt-static/images/status_icons/warning.gif">
                
                    Warning: If you set the basename manually, it may conflict with another entry.
                
                </p>
                <input type="hidden" value="0" id="basename_manual" name="basename_manual">
            
        
        </div>
    </div>
</div>