---
title: 'I&#8217;m a front-end dev!!'
author: Matt
layout: post
draft: true
categories:
  - Betfair
  - thoughts
  - work project
tags:
  - behaviour
  - Betfair
  - CSS
  - deployment
  - javascript
  - motivation
  - thoughts
  - work
---
This post could also be entitled/summarised with &#8220;rant, rant, rant&#8221;, but for my own sake, I&#8217;ll make the effort of explaining what&#8217;s behind it.

My full time job title is &#8220;Front-end developer&#8221;. To anyone outside the web industry, it either means &#8220;err&#8230;. no idea&#8221;, or &#8220;a dude that makes websites&#8221;. To the initiated and (most) of my coworkers and industry pals, it means a whole lot more: I&#8217;m an expert in HTML, CSS, javascript (front-end technologies)&#8230;<!--more-->

&lt;rant&gt;

Now, this could well stop here if I were to be very stubborn (and being French, I know a thing or two about stubbornness, trust me!), but I fortunately have a few other skills in my toolbox that actually help me do a whole lot more than JUST front-end code. That&#8217;s why I&#8217;m not just &#8220;a dude that makes websites&#8221;, but I&#8217;m also someone who knows about technologies and procedures of how to host these websites, their architecture, the communication protocols involved and what&#8217;s doable and acceptable both in a production and a development environment. This later one is the source of my rant.

You see, our applications at work run on tomcat, because they are written in java. While I have some issues with accepting this in the first place, it&#8217;s not the point of this post, is totally subjective, and is being debated <a href="http://stackoverflow.com/questions/2207073/struts-vs-zend-java-vs-php" target="_blank">all</a> <a href="http://100days.de/serendipity/archives/45-PHP-vs.-Java.html" target="_blank">over</a> <a href="http://onepixelahead.com/2010/03/04/php-vs-java-which-one-is-the-better-web-language/" target="_blank">the</a> <a href="http://stackoverflow.com/questions/621228/how-do-you-make-websites-with-java" target="_blank">web</a>. The problem is that when you build a website that intends to be highly reactive, as we do, then you also need to cater for the needs of front-end developers a lot more than a website rendering server-side composed JSP pages. Why? Simply because a lot of development effort is also going into front-end code.

As many of you experienced developers know, when you make changes to your java classes, you need to recompile your application, and then deploy it again by dropping a built war file in your tomcat container, or have the build process explode that file directly in a folder that is the docBase of your context for this web application. Sadly, this means that what you actually see when you browse the pages of your website comes from that later location, and not from the source files you edit.

Now this is fine in production because you (hopefully) don&#8217;t deploy there a new application every minute bearing some minor changes. But if you do a lot of front-end code in development, you have to constantly rebuild and deploy your application which imposes a lot of overhead and is totally impractical when all you want is clear your browser cache and reload the page.

Ok, I see you coming: why don&#8217;t you use <a title="eclipse.org" href="http://www.eclipse.org/" target="_blank">this</a> or <a title="intelliJ" href="http://www.jetbrains.com/idea/" target="_blank">that</a> IDE? It does \*everything\* for you! Right. Let me tell you why. I&#8217;ve been doing my work in an editor that I like, that I know, that I trust and that will not get in my way for most of the time. I simply can&#8217;t stand having to develop in a specific IDE \*just\* because everyone else is doing it, because the java dev is using this one for his own code, and because without it the application might not build properly. There are tools to build java applications like <a title="maven" href="http://maven.apache.org/" target="_blank">maven</a> and <a title="ant" href="http://ant.apache.org/" target="_blank">ant</a>, and they usually run fine. Just imposing an IDE on your developers for building an application is ridiculously stupid and short sighted. Don&#8217;t laugh, I&#8217;ve even seen so called &#8220;java devs&#8221; developing an application so it could \*only\* run in netbeans and the install guide started with &#8220;download netbeans&#8221;. No thanks! I am however aware that IDEs help a lot in compilation and takes care of the heavy lifting of linking packages and classes, which is fine, because it&#8217;s been created exactly for that! For front-end code? Not so much.

So after being told at work to &#8220;deal with it&#8221; by one of the java developers behind the new application we now all work on, I tried! I wasted (there&#8217;s no other word) 3 full days in trying to configure the application and all the build tools required to obtain a runnable artifact on my machine, and I managed to get it to run. (But remember: I&#8217;m still a front-end dev!) I&#8217;ve now done 3 days of java builds with maven and deployments in tomcat.

Then I wanted to work on my front-end code, only to discover (well, I knew that before, but I somewhat hoped this would have been taken care of in this application) that every time I wanted to see changes reflected in my browser, I had to rebuild the application and redeploy it. For some reason, this takes 2 full minutes&#8230; Can anyone justify 2 minutes for every front-end code edition and a page refresh? I don&#8217;t think so.

I&#8217;m fine with setting up an environment and following instructions for things I don&#8217;t know, and as a matter of fact I do it regularly as I have to know how to install simple web servers for my usual work, be it apache with php or ruby on rails with webrick and passenger. But just dumping front-end devs in a java dark hole with no more help than &#8220;deal with it&#8221; is incredibly unfair and unprofessional.

I&#8217;m a front-end developer.

So please please please, java developers working in collaboration with front-end developers building rich internet applications or any other site requiring a fair deal of front-end code: partner with them to find solutions to this development environment setup nightmare! It will make everyone happier!!

&lt;/rant&gt;