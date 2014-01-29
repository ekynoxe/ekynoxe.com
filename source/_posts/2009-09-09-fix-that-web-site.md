---
title: Fix that Web Site!
author: Matt
layout: post
categories:
  - Apache
tags:
  - Apache
  - DNS
---
I can&#8217;t recall how many times I&#8217;ve entered a domain name in a browser, say &#8216;domain.com&#8217;, only to wait 30 seconds and get an ugly 502 Bad gateway error in return.
The problem? Enter http://domain.com instead of http://www.domain.com and see what happens.

1. you are served the expected website, the url stays the same
2. you are redirected to http://www.domain.com or some other url
3. you get a 502, Bad gateway timeout

I don&#8217;t know if it&#8217;s laziness, lack of knowledge or simply host providers being plain rubbish, but it&#8217;s an annoying problem that can be solved extremely simply!

<!--more-->
Most of websites that are not configured properly often get away with it as many internet users believe that &#8216;www&#8217; is a compulsory part of any web URL.

In fact it&#8217;s only because of an old practice of naming hosts according to the services they provide, in our case a web site, with www. FTP using ftp.domain.come etc.
But it has nothing to do with any technical issue or any standard.
Not many (if any) &#8216;Mr average&#8217; know this!

One of the problems is that with the advent of new web browsers that suggest you URLs from your history, or even perform straight away an interactive search of web resources that match your typing, it is very easy to fall into the usual consumer laziness and let the browser find everything for you. That way, you get into the habit of accessing a website just by typing the domain name, without www or any other prefix, and sometimes even without the top level domain (The &#8216;.com&#8217; or other &#8216;.something&#8217;).

I&#8217;m the first to do it and that&#8217;s why I probably end up on these poorly configured web servers from time to time.
But I am still quite astonished to it see happen, as it can seriously lead to some misunderstanding from the average user. If I don&#8217;t know anything of internet, don&#8217;t care about &#8216;www&#8217;s, just type a domain name in my browser and get an error page, I&#8217;m not going to try very long to search for how to access that site!

That problem has a simple solution though.

First, if you have access to them, check your DNS records.
This step might not be compulsory, but it won&#8217;t harm to check them anyways.
Your domain will have an A record to point your domain name to the IP of the host of your web site:

<pre>
    domain.com        A         0.0.0.0
</pre>

You can also add either an A or a CNAME record for the www sub-domain. The syntax differs:

<pre>
    domain.com            A 0.0.0.0
    www.domain.com        A 0.0.0.0
    www.domain.com CNAME domain.com.
</pre>

Second, check your web server configuration that it actually is accepting requests from sub-domains and serving the proper files.
In Apache, for example, you can set it up by adding a virtual host:

<pre>
    Listen 80
    NameVirtualHost *

    &lt;VirtualHost *&gt;
    ServerName www.domain.com
    DocumentRoot /home/httpd/htdocs/
    &lt;/VirtualHost>

    &lt;VirtualHost *&gt;
    ServerName domain.com
    DocumentRoot /home/httpd/htdocs/
    &lt;/VirtualHost&gt;
</pre>

or using a server alias:

<pre>
    Listen 80
    NameVirtualHost *

    &lt;VirtualHost *&gt;
    ServerName domain.com
    ServerAlias www.domain.com
    DocumentRoot /home/httpd/htdocs/
    &lt;/VirtualHost&gt;
</pre>

So yes, I admit, you have to have access to the DNS entries and the configuration files of the server. But even if you don&#8217;t and it&#8217;s down to the host provider to configure the DNS and the web server files, it is very easy to set these up properly.

Ok, again, you might argue that you could serve a different version of the site with http://domain.com and http://www.domain.com, but if you don&#8217;t and there is no redirection in place, just make sure you don&#8217;t serve a 502.