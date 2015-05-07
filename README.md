# ID Shorts

This plugin provides a way to pass an entry ID or other shortcode to a cgi
script and have it send the user to the entry permalink.

## Creating the shortcode

The plugin allows for several kinds of shortcodes that may be used, all can be
created from the edit entry screen:

<img src="https://img.skitch.com/20110307-gaihm4n6dfi8kjhgxumt1wgtaw.png" style="border: 1px solid #333"/>

1. The entry id - this is the default value and can be used for any entry by
   visiting `http://example.com/mt-directory/mt/id-shorts.cgi?id=[mt:EntryID]`
2. An auto-generated "shortcode" - click the "Generate Shortcode" link to
   autogenerate a shortcode that can be passed to the cgi:
   `http://example.com/mt-directory/mt/id-shorts.cgi?id=[shortcode]`
3. A custom code or vanity path, entered into the **Short URL Path** field

After a value has been saved for the entry, a "Link" link will appear next to
the "Generate Shortcode" link. This link will let you copy or visit the
existing shortcode for an entry or page.

Using the "Generate Shortcode" link will hide the "Link" link until the entry
is resaved, as the old link will no longer be valid.

<img src="https://img.skitch.com/20110307-msdftt1qwwy47ui8jay59cbf7x.png" style="border: 1px solid #333" />

*WARNING: Changing the shortcode or vanity path for an entry will break any
existing links to that shortcode.*

## Prerequisites

* Movable Type 4.x, 5.x, or 6.x

## Installation

Unarchive the plugin and copy `id-shorts.cgi` into your main Movable Type
directory. Copy the contents of the `plugins/` folder into your `plugins/`
directory.

## Usage

1. Edit an entry or page
2. Find the **Short URL Path** setting under "basename":<br />
   <img src="https://img.skitch.com/20110307-xshg3f688qaq2sr9rtmhaekwnb.png" style="border: 1px solid #333" />
3. Generate a random shortcode for the entry or page, or enter a custom path
4. Save the entry.
5. Click on the "Link" link next to the shortcode field to visit the short
   url.
4. Get sent back to the entry or page's permalink.

### Rewrites

This plugin works best when you combine it with a tool like Apache's
mod_rewrite. Add this to your Apache config or .htaccess file:

    RewriteEngine On
    RewriteRule ^(\d{1,6})$ /cgi-bin/mt/id-shorts.cgi?id=$1&blog_id=<mt:BlogID> [L,R]

This says any one to six digit string after the hostname will be passed to
`id-shorts.cgi` through the parameter `id`. Of course, you'll want to change
the path to match the actual location of your MT install and make the sure the
matched text doesn't conflict with a file or another rewrite rule. Also note
that the `blog_id` parameter passes the current blog ID along; this is
optional but required if you want to serve blog-level 404 Documents. After
this, you should be able to visit http://super-awesome-url.biz/[mt:EntryID]
and go to the entry.

### Tags

This plugin adds the `<mt:entryshorturl>` tag. The output of this tag is based
on the blog level plugin setting for the short url template, which defaults to
`<mt:blogurl><mt:var name='id_shorts_path' />`.

### Plugin Settings:

IdShorts provides two blog-level plugin settings, and one system-level
setting. The blog-level settings are:

* **Track Clicks**: With this option selected, IdShorts will record each time
  an entries short url is clicked, and display this value on the edit entry
  (or page) screen.
* **Short URL Template**: This micro-template should be updated to match any
  custom paths set in your apache rewrite rules. For example, if you limit
  shorted urls to a `/s/` namespace on your server, your **Short URL
  Template** value should be `<mt:blogurl>/s/<mt:var name='id_shorts_path' />`.
* **Append Query Parameter**: If Google Analytics is used on your site, this
  option will be useful to track visits to a page vs visits to a page coming
  from a shortcode. The query parameter and value `utm_medium=go` will be
  appended to the redirected URL.
* **404 Document**: Because IdShorts can be configured (via mod_rewrite) to
  look for a short url when a file or directory is not found, it can bypass
  Apache's `ErrorDocument 404` handling. In these (hopefully rare) cases, you
  can tell IdShorts what file to serve to users to when both a file-system
  check and a short-url check have failed.

Note that the 404 Document plugin setting exists at both the system and blog
levels. A blog-level 404 Document will be loaded, if specified, and the
system-level 404 Document will serve as a fall-back. This way, a single 404 at
the system level can handle all 404 requests for a multi-blog installation,
but a single blog can have a custom 404 or can be served for a different
domain, for example.


## Credits

* IdShorts was written by David Raynes <rayners@rayners.org>
* Additions were made by Steve Ivy <steve@wallrazer.com>, courtesy
  of [Endevver Consulting](http://endevver.com),
  [Byrne Reese](http://majordojo.com), and Dan Wolfgang of
  [uiNNOVATIONS](http://uinnovations.com).
* The NewBase60 javascript used in generating random alpha-numeric shortcodes
  is courtesy Tantek Çelik: <http://tantek.pbworks.com/NewBase60>, translated
  from the original CASSIS by Edward O'Connor <hober0@gmail.com>, and was
  released under CC BY-SA 3.0
  <http://creativecommons.org/licenses/by-sa/3.0/>. Steve Ivy made some tweaks
  to remove `$`s.
* Testing and Generally Inspiring Fellow: Matt Jacobs
