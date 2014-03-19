---
layout: post
title: "Migrating comments and the quest for a lightweight solution"
written_on: 2014-03-15 19:13
date: 2014-03-18 21:43
categories:
- Jekyll
- work project
---

When I [migrated to jekyll](/on-jekyll/), I also wanted to migrate all my comments. My site doesn't have that many of them, so I thought it should have been a doddle to do it, and I was initially firmly set on using [Disqus](http://disqus.com/). It seemed simple, the embedded code interface didn't look too bad within my new website's design, and I didn't care that much about the fact that it works only with javascript.

<p class="attachement"><span><img src="{{ "comment.png" | image_path | cdn }}" alt="comments" /></span></p>

<!--more-->

Exporting my comments from Wordpress was very easy through WXR export file, and uploading them to Disqus was equally easy in the first instance.

However, I wasn't just moving my comments from Wordpress to Disqus under the same domain, but also changing said domain. And that's where the shine started to fade.

There is a domain migration tool provided by Disqus, but no matter how much I tried to migrate comments to the new URLs, I couldn't make it work.
Maybe I misunderstood something about the process, but the lack of feedback when creating a URL migration and the lack of documentation around the process is appalling at best.

The basic Disqus interface is probably OK as long as you stay in the confines of the bog-standard pathway, but for anything else, I found it to be very confusing. Very poor instructions, complete lack of feedback, and zero other on-line resources. The experience wasn't great. I even tried to contact their "customer support" a few times, but there again I didn't receive even the acknowledgement that my request had been received. I still haven't received anything to this day.

Over 5 days of experimentation, I tried to migrate the comments to domains on my local machine with a host file entry and on a real, live, website under a development domain of mine, just in case Disqus' back-end needed to verify that this domain worked somehow. I repeated the whole import / migration a few times, but nothing at all was indicating that I was going in the right direction.

Not a speck of light on anything was visible. So I've giving up on Disqus. If you're the standard user, you might be OK. If you have other needs: buzz off...

I had a look at a few other systems like [Moot.it](https://moot.it/), [Livefyre](http://web.livefyre.com/), and some others, but they either are too complex and expensive for what I need, or have no obvious support to import anything.

Given the waste of time, I have therefore pulled the plug entirely on using any existing third party commenting system at the moment. I think I've even come around to refusing to give the data of my website to a third party at all anyway.

In time, I'll create my very own commenting system, keeping ownership of my comments, and hopefully share that code with everyone for a self hosted solution that one can control entirely. It may be seen as reinventing the wheel, but I'll disagree. I won't create another Disqus, I'll create a solution for geeks who don't mind looking at a little bit of code, but mind a lot about where their content goes.

The basic requirements are pretty simple:

- A secure API for sending/fetching comments. No need for the posting side of things to even work through an interface
- An administration interface to manage comments, edit, delete, spam them etc... (I don't see myself doing it all command line!)
- Comment reply notifications
- It must be always on: no "Heroku 5 seconds spin up of death scenario..."
- Configuration options per post/page to accept/block or enable/disable comments
- Spam detection will be a must, and probably the trickiest one. But since a self hosted WP installation does it, there must be a way to replicate this with an Akismet key.

Things I don't need or care for

- Avatars
- Discussions. I want this solution to be just comments, and replies to comments. Other systems do discussions, and I'll happily leave it to them!
- Fancy mark-up. Everything will start by being stored as escaped HTML. Then it will be up to clients to use the correct parsers/highlighters. Whether they are JavaScript or ruby, I won't care.

In the mean time, you can send me an email with your comments, and I'll add them to the statically hosted ones on this site.
