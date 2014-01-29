---
title: Git on Gentoo?
author: Matt
layout: post
categories:
  - git
tags:
  - gentoo
  - git
  - gitosis
---
I wanted a while ago to set-up my own private git repositories on my vserver, but never got the time to dig into it properly.

I have installed git with gitosis on ubuntu and on mac osX several times in the past months, but I have to admit that although I&#8217;ve done it all in command line on the servers, the internals were still a bit obscure to me.
My vserver runs Gentoo, and initially I installed git and gitosis via emerge.<!--more-->

However, unlike my previous installs where I blindly (but successfully) followed the instructions and how-tos, I could not find anything else than how to [host a public repository on Gentoo][1]. Remember: these instructions are for a **public** repo!

That means that you&#8217;ll be able to **pull** from the server, but not **push**.

The explanation is simple: the way it&#8217;s presented will only ever user git-daemon, provided by git, that is designed to only server pull requests.

**These instructions work well** and in 10 minutes I had a public repo working flawlessly, but I wanted a private one where I could push my code and use it for automated deployments.

Killing git-daemon &#8211; Back to square one.
Like many out there, I guess, I followed the excellent [scie.nti.st][2] guide.

For Gentoo, this has to be changed slightly though.

Assuming you&#8217;ve setup git and it&#8217;s working fine
<pre>emerge -av dev-util/git</pre>

you haved cloned gitosis

<pre>git clone git://eagain.net/gitosis.git</pre>

and you are trying to install it

<pre>cd gitosis
python setup.py install</pre>

python setup tools might not be installed on your system.
On gentoo, to install them, use the following

<pre>emerge -av dev-python/setuptools</pre>

Adding the git user takes slightly different options too

<pre>adduser \
--system   \
--shell /bin/sh   \
--comment   'git version control'  \
--home-dir   /home/git   \
git</pre>

Now, the part that confused me, the gitosis init. As there is no sudo on my system (and I believe on many others), i could not execute the indicated command. Ok, no big deal in the end, just do by hand what the sudo options do for you:

By becoming the git user and switching to its home directory, you cover the -H and -u options of the sudo command that you&#8217;d otherwise use on other systems.

<pre>su git
cd /home/git</pre>

then run the init script with the public key of your remote account uploaded in the /tmp folder f your server
<pre>gitosis-init < /tmp/id_rsa.pub</pre>

Now follow the rest of the tutorial and you&#8217;re good to go.

Just one last thing, unlike the automatic emerge of the gitosis ebuild, your repositories will be in **/home/git/repositories** by default.

If you ALSO want public repositories, you can always use git-daemon when you want too. It works independently and can be in parallel of gitosis.

 [1]: http://en.gentoo-wiki.com/wiki/Git
 [2]: http://scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way/