
package IdShorts::CMS;

use strict;
use warnings;

sub cms_edit_entry {
    my ( $cb, $app, $id, $obj, $params ) = @_;

    require MT::Entry;
    return 1 if ( !$id );

    $params->{id_shorts_clicks} = $obj->id_shorts_clicks;
    $params->{id_shorts_path} = $obj->id_shorts_path;

    require IdShorts::Util;
    $params->{id_shorts_url} = IdShorts::Util->short_url_for($obj);

    return 1;
}

sub edit_entry_source {
    my ( $cb, $app, $tmpl ) = @_;

    $$tmpl
        =~ s/(\Q<li class="pings-link">\E.*?<\/li>)/$1<li class="short_clicks"><__trans phrase="[quant,_1,shorts click,shorts clicks]" params="<\$mt:var name="id_shorts_clicks"\$>"> on <a href="<\$mt:var name="id_shorts_url"\$>"><\$mt:var name="id_shorts_url"\$><\/a><\/li>/;
    
    my $short_field = <<"FIELDHTML";
    <script type="text/javascript">
    /* Tantek Çelik's NewBase60.
     *     http://tantek.com/
     *     http://tantek.pbworks.com/NewBase60
     *
     * Lightly translated from the original CASSIS to CommonsJS- &
     * Node.js-aware JavaScript by Edward O'Connor <hober0\@gmail.com>.
     *
     * Released under CC BY-SA 3.0:
     *           http://creativecommons.org/licenses/by-sa/3.0/
     *
     * Even More Lightly Edited by Steve Ivy <steve\@wallrazer.com>
     * for inclusion here
     */

    function numtosxg(n) {
        var s = "";
        var m = "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ_abcdefghijkmnopqrstuvwxyz";
        if (n===undefined || n===0) { return 0; }
        while (n>0) {
            var d = n % 60;
            s = m[d]+s;
            n = (n-d)/60;
        }
        return s;
    }

    function numtosxgf(n, f) {
        var s = numtosxg(n);
        if (f===undefined) {
            f=1;
        }
        f -= s.length;
        while (f > 0) {
            s = "0"+s;
            --f;
        }
        return s;
    }

    function sxgtonum(s) {
        var n = 0;
        var j = s.length;
        for (var i=0; i<j; i++) { // iterate from first to last char of s
            var c = s[i].charCodeAt(0); //  put current ASCII of char into c
            if (c>=48 && c<=57) { c=c-48; }
            else if (c>=65 && c<=72) { c-=55; }
            else if (c==73 || c==108) { c=1; } // typo capital I,
            // lowercase l to 1
            else if (c>=74 && c<=78) { c-=56; }
            else if (c==79) { c=0; } // error correct typo capital O to 0
            else if (c>=80 && c<=90) { c-=57; }
            else if (c==95) { c=34; } // underscore
            else if (c>=97 && c<=107) { c-=62; }
            else if (c>=109 && c<=122) { c-=63; }
            else { c = 0; } // treat all other noise as 0
            n = 60*n + c;
        }
        return n;
    }
    
    function make_random(){
        var s = Math.pow(2,32);
        var n = Math.floor(Math.random()*s);
        return numtosxg(n);
    }
    
    function generate() {
        document.getElementById('id_shorts_path').value = make_random();
        document.getElementById('short-link-link').style.visibility = 'hidden';
        return false;
    }
    
    </script>
    <mtapp:setting
        id="id_shorts_path"
        label="Short URL Path"
        hint="Short URL or vanity URL path (some/vanity/path with no leading /)<br/>Defaults to the entry ID."
        show_hint="1">
            <input type="text" name="id_shorts_path" id="id_shorts_path" value="<mt:var name="id_shorts_path" />" />
            <a href="javascript:return false;" onclick="generate()">Generate Shortcode</a><mt:if name="id_shorts_path"><span id="short-link-link"> | <a href="<mt:var name="id_shorts_url" />">Link</a></span></mt:if>          
    </mtapp:setting>
FIELDHTML
    
    $$tmpl =~ s/(<mtapp:setting.*?id="basename".*?<\/mtapp:setting>)/$1$short_field/xsm;
    # <input type="text" name="short_url_path" size="15">
    return 1;
}

sub pre_save_entry {
    my ($cb, $app, $obj, $original) = @_;
    if (my $path = $app->param('id_shorts_path')) {
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