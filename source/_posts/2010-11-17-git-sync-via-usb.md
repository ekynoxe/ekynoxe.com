---
title: Git sync via USB
author: Matt
layout: post
categories:
  - git
---
Right, suppose you need to sneakernet some git repository changes, Maybe your network is down and you want to send changes to co-workers or another machine from which you have a full network access. Maybe you’re somewhere without access to the a network and/or the correct ports/protocols for security reasons. Maybe all network connections are down and you really need to transfer your changes to someone else. How do you go about that?
<!--more-->

Of course, there is the [git-bundle][1] solution, but I feel it is probably more suited to large projects where you only need to sync changes about small parts of the code base, rather than the whole repo, and it involves creation of bundle files which I was not too happy about doing.

I therefore went instead on the route of creating a normal repo on my USB stick and using it as the transport mean. This involves creating a bare repo on the usb stick and adding the correct remote branches on machines either side of the transfer.

I&#8217;m working on a mac, so you&#8217;ll have to adapt the paths to your own situation. My USB stick is mounted on

<pre>/Volumes/USB_STICK/</pre>

## On USB stick, from machine A

All you need to do is set up bare repo (and that&#8217;s all!)

<pre class="brush: bash; light: true; title: ; notranslate" title="">machineA$ cd /Volumes/USB_STICK/desired_repo_path/
USB_STICK$ git init --bare
</pre>

## On machine A (holding the initial code)

First, set up your git repository normally if it&#8217;s not already done:

<pre class="brush: bash; light: true; title: ; notranslate" title="">machineA$ cd /my/files/path/
machineA$ git init
machineA$ git add .
machineA$ git commit -m "initial commit"
</pre>

Then simply add a remote branch pointing at the usb stick repo

<pre class="brush: bash; light: true; title: ; notranslate" title="">machineA$ git remote add stick /Volumes/USB_STICK_NAME/desired_repo_path/
machineA$ git push stick master
</pre>

You have now pushed your complete repository (the master branch to be more precise) on the usb stick. All you need to do is to pull it from your second machine!

## On machine B (Where you want to transfer the code to)

Set up a new repository to receive the code, add a remote branch from the stick and pull the changes as you would normally do

<pre class="brush: bash; light: true; title: ; notranslate" title="">machineB$ cd /path/where/IWant/My/Files/
machineB$ git init
machineB$ git remote add stick /Volumes/USB_STICK_NAME/desired_repo_path/
machineB$ git pull stick master
</pre>

You now have transferred your code from MAchine A to Machine B, and you can work normally on this machine, committing as you normally would. Then, to transfer the changes back to machine A. Nothing more simple:

## On machine B

<pre class="brush: bash; light: true; title: ; notranslate" title="">machineB$ git push stick
</pre>

## On machine A

<pre class="brush: bash; light: true; title: ; notranslate" title="">machineA$ git pull stick
</pre>

From there, if you have set up a remote tracking branch on a network server that co-workers pull from of from which you checkout code for deployment, you can now do a simple

<pre class="brush: bash; light: true; title: ; notranslate" title="">machineA$ git push
</pre>

And you&#8217;re good!

 [1]: http://www.kernel.org/pub/software/scm/git/docs/git-bundle.html