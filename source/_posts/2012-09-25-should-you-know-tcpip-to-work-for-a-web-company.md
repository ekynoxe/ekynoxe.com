---
title: Should you know TCP/IP to work for a web company?
author: Matt
layout: post
categories:
  - work
tags:
  - development
  - IP
  - network
  - Tcp
  - web
---
An interesting discussion (argument?) popped in my tweets yesterday in the form of TCP/IP knowledge depth to be able to work at a web company.

<p class="attachement"><a href="http://blog.ekynoxe.com/wp-content/uploads/2012/09/20120924-1836191.jpg" rel="lightbox[1397]" title="20120924-183619.jpg"><img src="http://blog.ekynoxe.com/wp-content/uploads/2012/09/20120924-1836191-300x217.jpg" alt="The tweet that prompted it all"/></a></p>

That quickly prompted quite a few replies from developers and techs leads of different levels and knowledge, including myself, but none of us asked the question: &#8220;for which role?&#8221;
<!--more-->

There are a lot of different roles at a web company, and if we exclude the obvious non techies ones (I doubt the receptionist gives a damn about MTU and error control), we can still argue about the depth of network knowledge required to occupy a technical role.
Let&#8217;s be clear here: we&#8217;re **not** talking about connecting your laptop to your corporate wifi network, but about network protocols and how they work.

**The pure front-end developer: ** I&#8217;d argue you only need some very small basics, if any, about network protocols to do an awesome job without any problem. I hope you know what an IP address is, and that&#8217;s possibly the only thing you&#8217;ll need. If you don&#8217;t, dig it up, but don&#8217;t learn the whole CCNA syllabus. No need. Knowing HTTP, on the other hand, is not an option these days, even for &#8220;pure front-enders&#8221; who&#8217;ll most likely have to do something with asynchronous javaScript calls at some point or another.

**The all rounder**: If, like me, you&#8217;re one of those, doing some front end and backend code, you&#8217;ll probably want to know a bit more about what rules data transfers across networks. Having a little knowledge about network protocols, what they generally do and how to ping/trace stuff is a good thing. But I am really not convinced that knowing the inner workings TCP/IP should be a requirement to land you a job. Hands up all rounders who have had to dig in TCP retransmission timeouts or the size of IP datagrams because some packets were being dropped on &#8220;the line&#8221;? Yeah&#8230; I thought so. Probably not many, and the ones who raised their hands either do a networks engineer&#8217;s job, or, like me, did some network studies before falling into development.

**The back-ender:** It&#8217;s probably a very good asset to have, especially if you work at a web company dealing with large volumes of users, requests, page loads and transactions. Knowing it will probably help a lot in optimisation of data transfers an server communications. I&#8217;d argue here that it is a requirement for you to know where things happen on the network stack. You won&#8217;t need it every day in your job, but you&#8217;ll have an extra weapon in your arsenal in case things get nasty in those lower layers. Having said that, if you don&#8217;t work on networks systems, I&#8217;m pretty sure you can still do an excellent job without the complete knowledge of how IP re-assembles packets or how TCP works out how to retransmis the ones gone astray&#8230;

Now if you&#8217;re interviewing for a network or systems engineer role, then you should not only know what TCP/IP is, but know its inner workings and its quirks. You should know how to trace errors in packets and be able to identify why some retransmission occurs on the networks you&#8217;ll be managing. At this level, basics aren&#8217;t enough anymore, but this is valid in any IT networks department, regardless of the company.

As with everything, it&#8217;s all a matter of perspective (and remember I&#8217;m more an all-rounder with a strong preference on front-end development), but I&#8217;d argue you don&#8217;t need a very deep understanding of the inner workings TCP/IP and how it works to &#8220;work at a web company&#8221;.

What&#8217;s **your** view?