# ID Shorts

Author: David Raynes

Testing and Generally Inspiring Fellow: Matt Jacobs

## Overview

This plugin provides a way to pass an entry ID to a cgi script and have it send
the user to the entry permalink.

## Installation

Unarchive the plugin and copy `id-shorts.cgi` into your main Movable Type
directory. Copy the contents of the `plugins/` folder into your `plugins/`
directory.

## Usage

1. Visit http://super-awesome-url.biz/mt-directory/mt/id-shorts.cgi?id=[mt:EntryID].

2. Get sent back to the entry's permalink.

3. Profit!

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
`<mt:blogurl><mt:entryid>`.

