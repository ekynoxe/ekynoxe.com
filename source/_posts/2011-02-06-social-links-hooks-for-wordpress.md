---
title: Social Links hooks for WordPress
author: Matt
layout: post
categories:
  - wordpress
tags:
  - development
  - plugin
  - wordpress
---

<p class="attachement"><img src="{{ "Picture-5.png" | image_path | cdn }}" alt="Social links hooks plugin panel" /></p>

I&#8217;ve created a very simple plugin to display handy little icons where you want in your wordpress theme.<!--more-->

<p class="attachement"><img src="{{ "Picture-7.png" | image_path | cdn }}" alt="example 1" /></p>

<p class="attachement"><img src="{{ "Picture-6.png" | image_path | cdn }}" alt="example 2" /></p>

Download on github at <https://github.com/ekynoxe/Social-link-hooks-for-Wordpress>

Options are really simple, you pass them as an array as in the example below:

*   **show_labels**: displays the name of the social network next to the icon. *default: true*
*   **before**: the tag to display before the link. *default: &lt;dd&gt;*
*   **after**: the tag to display after the link. *default: &lt;/dd&gt;*

Put this code in your functions.php

<pre class="brush: php; title: ; notranslate" title="">function print_social_links(){
  if ( class_exists( 'SocialLinksHooks' ) ):
    $sl_hooks = new SocialLinksHooks();
    $sl_hooks-&gt;printLinks(array('show_labels'=&gt;false,'before'=&gt;'', after=&gt;''));
  endif;
}
</pre>

Then, in your template, wherever you want, call the above function:

<pre class="brush: php; title: ; notranslate" title="">print_social_links();</pre>

Extending it should be a breeze for any PHP developer.
That&#8217;s it!