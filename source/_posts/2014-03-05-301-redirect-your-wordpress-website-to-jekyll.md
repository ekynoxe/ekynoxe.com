---
layout: post
title: "301 redirect your Wordpress website to Jekyll"
written_on: 2014-03-03 19:38
date: 2014-03-05 21:49
categories:
- Jekyll
---

If you're migrating a Wordpress install to Jekyll, and changing your URLs structure at the same time, you'll need to generate redirects for your old URLs.

<p class="attachement"><span><img src="{{ "301.png" | image_path | cdn }}" alt="301 permanent redirect" /></span></p>

<!--more-->
Here's a plugin that does that for you: give it the source and destination domains, and when you generate your Jekyll website, it creates a file pre-formatted with all you need to migrate your old URLs.

Simply drop the result in the .htaccess of an Apache install and you're good to go.

At the time of writing, this plugin only supports one source URL scheme, and one destination scheme:
The source URLs must be formatted as **<olddomain>/year/month/day/post-slug**, while the destination will be**<newdomain>/post-slug**

The configuration options are directly inside the code and speak for themselves. You might not need to set a value at all for the source domain, but it's there if you need it.

<pre><code>@@sourceDomain = ""
@@targetDomain = "http://www.ekynoxe.com"
@@RedirectsFileName = "htaccess_redirects"
</code></pre>

Here's a sample of what it generated for my own site:
<pre><code>...
RedirectMath 301 /2010/08/09/mastermind/? http://www.ekynoxe.com/mastermind/
RedirectMath 301 /2010/09/01/what-really-motivates-us/? http://www.ekynoxe.com/what-really-motivates-us/
RedirectMath 301 /2010/09/06/extending-contact-form-7/? http://www.ekynoxe.com/extending-contact-form-7/
RedirectMath 301 /2010/09/12/create-a-deep-space-background-in-photoshop/? http://www.ekynoxe.com/create-a-deep-space-background-in-photoshop/
RedirectMath 301 /2010/10/24/this-is-it/? http://www.ekynoxe.com/this-is-it/
...
</code></pre>

The source code is on Github in the [Jekyll 301 Redirects Generator](https://github.com/ekynoxe/JekyllRedirectsGenerator)

If you prefer copy / paste, here it is too:

<pre><code># encoding: utf-8
#
# Jekyll 301 Redirects Generator plugin for Wordpress site migration
# http://www.ekynoxe.com/
# Version: 0.0.1 (2014-03-04)
#
# Copyright (c) 2014 Mathieu Davy - ekynoxe - http://ekynoxe.com/
# Licensed under the MIT license
# (http://www.opensource.org/licenses/mit-license.php)
#
# This plugin creates a list of 301 redirects from old Wordpress urls to new ones.
# It currently only supports one source url structure
#   and one target structure:
#
#   source:    <olddomain>/year/month/day/postname
#
#   target:    <newdomain>/postname
#
module Jekyll

    # Sub-class Jekyll::StaticFile to allow recovery from unimportant exception
    #   when writing the redirects file.
    # I don't like this but that seems to be the only way to get around Jekyll
    #   StaticFile class using "cp" instead of "rename"
    # Found on the SiteMap Generator at
    #   https://github.com/recurser/jekyll-plugins/blob/master/generate_sitemap.rb
    class RedirectsFile < StaticFile
        def write(dest)
            super(dest) rescue ArgumentError
            true
        end
    end

    class RedirectsGenerator < Generator
        safe true
        priority :low

        @@sourceDomain = ""
        @@targetDomain = "http://www.ekynoxe.com"
        @@RedirectsFileName = "htaccess_redirects"

        def generate(site)
            mappedUrls = []

            site.posts.each do |post|
                post_name = post.name.gsub(/\.md$/, "")
                url_parts = post_name.match(/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.+)/i)

                mappedUrls << "RedirectMath 301 " + File.join(@@sourceDomain, url_parts[1], url_parts[2], url_parts[3], url_parts[4]) + "/? " + File.join(@@targetDomain, url_parts[4]) + "/"
            end

            site_folder = site.config['destination']
            unless File.directory?(site_folder)
                p = Pathname.new(site_folder)
                p.mkdir
            end

            File.open(File.join( site_folder, @@RedirectsFileName ), 'w') do |f|
                mappedUrls.each do |line|
                    f.write line + "\n"
                end

                f.close
            end

            site.static_files << Jekyll::RedirectsFile.new(site, site.dest, '/', @@RedirectsFileName)
        end
    end
end
</code></pre>
