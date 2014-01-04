---
title: Zend and Xdebug
author: Matt
layout: post
categories:
  - Zend
tags:
  - xdebug
  - Zend
---
After having coded most of my sites all from scratch with some of my own libraries, I am getting into using Zend framework, PHPUnit, and Xdebug.

If the two first ones have been of little trouble to install, I can&#8217;t say the same for Xdebug.

<!--more-->
At first I have followed all the common tutorials that you can find around the web:

*   downloading the pre-compiled xdebug.so for my PHP install
*   simply copying to the proper folder
*   modifying my php.ini configuration by adding the correct zend_extension parameter for [xdebug].

Until here, nothing fancy, it seems to work for most. BUT, when every install how-to on the web says &#8220;that&#8217;s it you&#8217;re done&#8221;, nothing happened for me. Xdebug was not loaded, there was no error message and everything was still running fine.

That&#8217;s when things started to get complicated, given the amount of combination possible of wrong configuration parameters and pre-compiled available shared objects, **all of which would fail silently if anything would go wrong**.

I tried to change zend\_extension to zend\_extension_ts because I was running PHP 5.2.8, but this did not change anything, I tried to compile xdebug.so manually and use the compiled object with the several parameters combination I have already tested with the pre-compiled version&#8230; Nothing. not single error or idicatio that could put me on the right way!

Then, I came across an old article on [devzone.zend.com][1] that I have discarded at first for its age (December 2007&#8230;) but that I ended up reading thoroughly and the following lines flashed before me:

*Please note that phpize and php-config must match the PHP version you are using, so do not just copy them to your system from some other PHP installation. When your development tools are in place, you can download and compile xdebug*

The phpize command on my system was not pointing to the proper one, as I compiled my own AMP install on the Mac. Running the proper phpize (in /usr/local/php/bin/ for me), it gave kind of a weird result:

<pre>PHP Api Version: 20041225
Zend Module Api No:
Zend Extension Api No:</pre>

Yep! No Zend API version numbers at all. As phpise is a simple shell script that extracts the API numbers from the PHP and Zend configurations, I thought there was a problem simply with my PHP install, and not with xdebug at all.

As I was running 5.2.8, I upgraded to PHP 5.3, cleaned all xdebug.so files, cleaned my php.ini file and tried it all again!

The pre-compiled version **DID NOT WORK** either, but compiling it myself from source, this time phpize giving the right API numbers:

<pre>PHP Api Version: 20090626
Zend Module Api No: 20090626
Zend Extension Api No: 220090626
</pre>

And finally xdebug worked!
So, a few things to remember:

*   sort your PHP install properly first, with the commands pointing to the right places. That&#8217;s also valid for php-config that is required for the compilation of xdebug
*   trying the pre-compiled version might not work on your system, so compile your own, it&#8217;s simple enough and the article on zend.com(<http://devzone.zend.com/article/2803>), albeit old, is still valid

 [1]: http://devzone.zend.com/article/2803