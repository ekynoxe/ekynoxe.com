---
title: WordPress wp_enque_scripts in functions.php
author: Matt
layout: post
categories:
  - wordpress
tags:
  - php
  - syntax
  - wordpress
---
The functions.php file should be known to every wordpress theme developer, as it&#8217;s where all your custom theme code is expected to go, including the loading of special files, scripts and overriding the default, out-of-the-box wordpress functions and javascript files.

However, there are a few things one need to remember when writing code in that file, and it&#8217;s not always easy to understand. Specifically, registering and enqueueing scripts can be a bit tricky if you don&#8217;t understand how the functions.php file is loaded.

One of the biggest problem is understanding the scope and load/execution time of what is in that file. I&#8217;ve scratched my head a few times on it, and hopefully, I now understand it better and will manage to write it down correctly!
<!--more-->

## Scope

First of all, if you look for a functions.php file in your wordpress installation: beware! There is also a file called functions.php in the wordpress core files in the wp-includes folder. We&#8217;re NOT talking about this one! We are talking about creating your own functions.php file in your <span style="text-decoration: underline;">theme folder</span>. So don&#8217;t go edit the core one (one should NEVER edit the core files anyways) and instead work on your own, clean and empty version located in your theme directory.

Now, about scope: the functions.php file in your theme is included from the following flow:

*   a request arrives on your web server and process the index.php file.
*   this includes wp-blog-header.php
*   in turn this one includes wp-load.php
*   that file eventually loads wp-config.php (you should know that file!)
*   this config file then includes wp-settings.php
*   wp-settings.php, after doing a whole load of stuff, includes your theme&#8217;s functions.php file (at last!)

Because all of these includes happen in the files directly, using php&#8217;s include() function, and not in nested calls, they all inherit the global scope, and so does your functions.php file, but it&#8217;s not really important as we&#8217;ll see later on. What is important however, is the time in the whole page load process when the functions.php file is loaded: it happens before (read well: BEFORE) the wp-init() call is placed, which will then execute all actions, hooks and eventually render the requested page. If you&#8217;re interested in more details about what happens in this phases, more details are (and will be available in the near future apparently) on a post just written (funny enough, only a few days ago!), on <a title="What wordpress does before init" href="http://wordpressinternals.com/2011/08/what-wordpress-does-before-init/" target="_blank">wordpressinternals.com</a>

At this point, before the theme is loaded and right before the functions.php file of your theme is loaded, you have access to some global functions like is\_admin(), and more importantly, wp\_deregister\_script(), wp\_register\_script() and wp\_enqueue_script().

That&#8217;s where it gets interesting, these functions are available to use, but if not carefully wrapped in hooks or actions, they will not return the inteded results. That&#8217;s what I was doing wrong, and that&#8217;s what prompted me to do this write up.

## What was I doing wrong?

Basically, I was coding my theme the wrong way by not wrapping these tests in a hook or action, well before the WP init was called, as described on a <a title="Doing it wrong" href="http://core.trac.wordpress.org/ticket/11526#comment:14" target="_blank">wordpress development track ticket</a>. Like many theme developers, I guess, I started to write my new theme by using an existing one, and modified the functions.php file. Along the way I found great resources like <a title="digwp's functions.php template" href="http://digwp.com/2010/03/wordpress-functions-php-template-custom-functions/" target="_blank">digwp&#8217;s functions.php template</a>. Initially happy enough to have something working, while blissfully ignorant about its internals, I started to get a strange behaviour when I wanted to include scripts only on some specific pages of my theme.

At the top of my <span style="text-decoration: underline;">functions.php</span>, I had left the template file function calls to enqueue the scripts:

<pre class="brush: php; title: ; notranslate" title="">wp_deregister_script('jquery');
wp_register_script('jquery', (get_bloginfo('stylesheet_directory')."/js/jquery-1.4.2.min.js"));
wp_enqueue_script('jquery');
</pre>

Lets say I want to add a script only on the home page. I&#8217;ve got a custom home page for my theme, so I&#8217;m using is\_front\_page() to detect it. I therefore added:

<pre class="brush: php; title: ; notranslate" title="">if( is_front_page()) {
	wp_register_script('home_script', (get_bloginfo('stylesheet_directory')."/js/home.js"));
	wp_enqueue_script('home_script');
}
</pre>

I also have custom templates like a &#8220;alternatepage.php&#8221; template file, so to detect it, I used the is\_page\_template() function:

<pre class="brush: php; title: ; notranslate" title="">if( is_page_template('alternatepage.php')) {
	wp_register_script('alternatepage_script', (get_bloginfo('stylesheet_directory')."/js/alternatepage.js"));
	wp_enqueue_script('alternatepage_script');
}
</pre>

Simple enough eh? Errrrr&#8230;. no!

Access any of these pages and the required scripts will not get loaded.

## Why does this not work?

The answer is fairly simple, providing you know the existence of the WP and WP_Query objects, and if you followed until here (and understood where I was going with the inclusion of php scripts).

At the point where the functions.php file is loaded, when the is\_front\_page and is\_page\_template functions are called (Remember? When you include a php script it gets evaluated as part of the include process!), <span style="text-decoration: underline;">no query has been made yet, therefore both functions will return false</span>!

So how can I include only the scripts I require on the pages I want? <a title="Wordpress actions" href="http://codex.wordpress.org/Plugin_API#Actions" target="_blank">Actions</a> to the rescue!!

## Which action do I need

Trawling through the <a title="Action reference" href="http://codex.wordpress.org/Plugin_API/Action_Reference" target="_blank">actions list</a>, there is one obvious action that should jump before your eyes: wp\_enqueue\_scripts. It&#8217;s executed right after the wp_head one, and is intended to allow theme developers to hook onto the moment in the page load where the platform enqueues its own scripts, adding theme specific ones.

All I had to do was to wrap my calls to change the enqueued script files into a function tied to this hook:

<pre class="brush: php; title: ; notranslate" title="">function register_scripts() {
	wp_deregister_script('jquery');
	wp_register_script('jquery', (get_bloginfo('stylesheet_directory')."/js/jquery-1.4.2.min.js"));
	wp_enqueue_script('jquery');

	if( is_front_page()) {
		wp_register_script('home_script', (get_bloginfo('stylesheet_directory')."/js/home.js"));
		wp_enqueue_script('home_script');
	}

	if( is_page_template('alternatepage.php')) {
		wp_register_script('alternatepage_script', (get_bloginfo('stylesheet_directory')."/js/alternatepage.js"));
		wp_enqueue_script('alternatepage_script');
	}
}
add_action( 'wp_enqueue_scripts', 'register_scripts' );
</pre>

All is fine now and the correct scripts are loaded on the right pages, but gosh it took some time to drill down the core of wordpress to understand what was going on!

## My advice?

Only use hooks in your functions.php unless you have a very good reason not to!