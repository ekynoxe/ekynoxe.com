---
title: The day one image brought my server down
author: Matt
layout: post
permalink: /2012/09/15/the-day-one-image-brought-my-server-down/
categories:
  - Apache
tags:
  - Apache
  - configuration
  - crash
  - latency
  - memory
  - server
---
During the viral expansion of the &#8220;Richmond news paper editorial fiasco&#8221;, I submitted [a post on the road.cc forum][1]. In it, I had added an image linked straight from my server&#8230; What a great idea! Linking one of the most read cycling forum in the UK to my own domain! Lots of hits! &#8230; yeah, just that.

<p class="attachement"><a href="http://blog.ekynoxe.com/wp-content/uploads/2012/09/one_image_host_down.png" rel="lightbox[1368]" title="One image on road.cc..."><img src="http://blog.ekynoxe.com/wp-content/uploads/2012/09/one_image_host_down-300x139.png" alt="One image on road.cc..." /></a></p>

I definitely need to do some memory tweaking there, because that single image, requested by the road.cc page views, brought my server to its knees. Not &#8211; good.

 [1]: http://road.cc/content/forum/65843-…-only-good-cyclist-dead-one-…”-–-editor-richmond-magazine-–-september-issue "“… the only good cyclist is a dead one …” – editor of the richmond magazine – september issue"