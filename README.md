# ID Shorts

Author: David Raynes
Extensions: Steve Ivy

Testing and Generally Inspiring Fellow: Matt Jacobs

## Overview

This plugin provides a way to pass an entry ID or other shortcode to a cgi script and have it send
the user to the entry permalink.

### Creating the shortcode

The plugin allows for several kinds of shortcodes that may be used, all can be created from the edit entry screen:

<img src="https://img.skitch.com/20110307-gaihm4n6dfi8kjhgxumt1wgtaw.png" style="border: 1px solid #333"/>

1. The entry id - this is the default value and can be used for any entry by visiting `http://example.com/mt-directory/mt/id-shorts.cgi?id=[mt:EntryID]`
2. An auto-generated "shortcode" - click the "Generate Shortcode" link to autogenerate a shortcode that can be passed to the cgi: `http://example.com/mt-directory/mt/id-shorts.cgi?id=[shortcode]`
3. A custom code or vanity path, entered into the **Short URL Path** field

After a value has been saved for the entry, a "Link" link will appear next to the "Generate Shortcode" link. This link will let you copy or visit the existing shortcode for an entry or page.

Using the "Generate Shortcode" link will hide the "Link" link until the entry is resaved, as the old link will no longer be valid.

<img src="https://img.skitch.com/20110307-msdftt1qwwy47ui8jay59cbf7x.png" style="border: 1px solid #333" />

*WARNING: Changing the shortcode or vanity path for an entry will break any existing links to that shortcode.*

## Installation

Unarchive the plugin and copy `id-shorts.cgi` into your main Movable Type
directory. Copy the contents of the `plugins/` folder into your `plugins/`
directory.

## Usage

1. Edit an entry or page
2. Find the **Short URL Path** setting under "basename":
   <img src="https://img.skitch.com/20110307-xshg3f688qaq2sr9rtmhaekwnb.png" style="border: 1px solid #333" />
3. Generate a random shortcode for the entry or page, or enter a custom path
4. Save the entry
5. Click on the "Link" link next to the shortcode field to visit the short url.
4. Get sent back to the entry or page's permalink.

### Rewrites

This plugin works best when you combine it with a tool like Apache's
mod_rewrite. Add this to your Apache config or .htaccess file:

    RewriteEngine On
    RewriteRule ^(\d{1,6})$ /cgi-bin/mt/id-shorts.cgi?id=$1 [L,R]

This says any one to six digit string after the hostname will be passed to 
id-shorts.cgi. Of course, you'll want to change the path to match the actual
location of your MT install and make the sure the matched text doesn't conflict
with a file or another rewrite rule. After this, you should be able to visit
http://super-awesome-url.biz/[mt:EntryID] and go to the entry.

### Tags

This plugin adds the `<mt:entryshorturl>` tag.  The output of this tag is based
on the blog level plugin setting for the short url template, which defaults to
`<mt:blogurl><mt:var name='id_shorts_path' />`.

