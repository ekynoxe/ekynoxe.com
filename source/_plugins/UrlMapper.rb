# encoding: utf-8
#
# Jekyll urls mapping plugin for site migration
# http://www.ekynoxe.com/
# Version: 0.0.1 (2014-01-26)
#
# Copyright (c) 2014 Mathieu Davy - ekynoxe - http://ekynoxe.com/
# Licensed under the MIT license
# (http://www.opensource.org/licenses/mit-license.php)
#
# This plugin creates a csv file in the site's public directory
#   containing mappings from old urls to the new ones.
# It currently only supports one source url structure
#   and one target structure:
#
#   source:    <olddomain>/year/month/day/postname
#
#   target:    <newdomain>/postname
#
# This has been built to generate what I need to migrate comments and a
#   base for my 301 redirects
#
module Jekyll

    # Sub-class Jekyll::StaticFile to allow recovery from unimportant exception
    #   when writing the sitemap file.
    # I don't like this but that seems to be the only way to get around Jekyll
    #   StaticFile class using "cp" instead of "rename"
    # Found on the SiteMap Generator at
    #   https://github.com/recurser/jekyll-plugins/blob/master/generate_sitemap.rb
    class StaticSitemapFile < StaticFile
        def write(dest)
            super(dest) rescue ArgumentError
            true
        end
    end

    class UrlMapper < Generator
        safe true
        priority :low

        @@sourceDomain = "http://blog.ekynoxe.com"
        @@targetDomain = "http://local.ekynoxe.com"
        @@UrlsFileName = "mapped-urls.csv"

        def generate(site)
            mappedUrls = []

            site.posts.each do |post|
                post_name = post.name.gsub(/\.md$/, "")
                url_parts = post_name.match(/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.+)/i)

                mappedUrls << File.join(@@sourceDomain, url_parts[1], url_parts[2], url_parts[3], url_parts[4]) + ", " + File.join(@@targetDomain, url_parts[4]) + "/"
            end

            site_folder = site.config['destination']
            unless File.directory?(site_folder)
                p = Pathname.new(site_folder)
                p.mkdir
            end

            File.open(File.join( site_folder, @@UrlsFileName ), 'w') do |f|
                mappedUrls.each do |line|
                    f.write line + "\n"
                end

                f.close
            end

            site.static_files << Jekyll::StaticSitemapFile.new(site, site.dest, '/', @@UrlsFileName)
        end
    end
end