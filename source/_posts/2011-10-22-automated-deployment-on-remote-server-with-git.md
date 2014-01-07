---
title: Automated deployment on remote server with git
author: Matt
layout: post
categories:
  - git
  - tools
tags:
  - deployment
  - git
  - server
---
Some time back, I wanted to setup my server so I could push code to my repositories, and have it automatically deployed to a website root directory after doing a git push from my local machine.
I can&#8217;t remember where I found the instructions so I can&#8217;t give credit to whom I got it from, but here&#8217;s how I did it.

This is followed by a tutorial on [how to extend this setup to multiple branches and work-trees][1] for &#8220;live&#8221; and &#8220;development&#8221; versions of a website.<!--more-->I use this method for small personal projects where I really only need one branch to be automatically deployed. I will assume you already have a local git repository (

<a title="Hosting Git repositories, The Easy (and Secure) Way" href="scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way" target="_blank">Head here</a> for instructions how to, this is still somewhat valid!) with some code in it under a branch called &#8216;master&#8217;, and that you will push code to a remote server holding both your repository and your web server.

## Create the remote repository (basic git setup)

### On server:

    mkdir /path/to/repo/project.git
    cd /path/to/repo/project.git
    git init --bare


### On local machine:

    cd /path/to/mycode
    git init
    git remote add origin git@yourserver:project.git

At this point (providing you have setup git on your server correctly, which I&#8217;m not going to cover here! This <a title="Hosting Git repositories, The Easy (and Secure) Way" href="http://scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way" target="_blank">how-to</a> is still valid) you should be able to simply push your code to your server with the usual command

    git push origin master

## Adding single branch automatic deployment

First, you&#8217;ll need a place to deploy your code to, that&#8217;s call the detached work tree from Git&#8217;s point of view because it&#8217;s a copy of the code without the history or references. I have both my repositories and webserver on the same machine so these instructions are for this configuration only. This detached work tree needs to be under your webserver&#8217;s root directory if you&#8217;re deploying a web site, but you could deploy that whatever place you want.

### On server:

Create the work-tree directory and make make sure the git user (or the one you use for git repositories) has permissions to write to this directory:

    mkdir /path/under/root/dir/project
    chown git:git /path/under/root/dir/project

Then, you need to add a bit of configuration to your repository (created above):

    cd /path/to/repo/project.git
    git config core.worktree /path/under/root/dir/project
    git config core.bare false
    git config receive.denycurrentbranch ignore

Finally, all you have to do is create and make executable a &#8220;post-receive&#8221; hook in your repository&#8217;s hooks folder:

    cd /path/to/repo/project.git/hooks/
    touch post-receive
    chmod +x post-receive
    vi post-receive

And paste this code into this file:

    #!/bin/sh git checkout -f

And voilà! Next time you push new changes from your local machine to the main server, the default (master) branch will be automatically checked out from your repository into the detached working tree.

***EDIT:** Following Luca&#8217;s comments below, it&#8217;s worth noting that if you have no local changes, nothing will get pushed, and the hook will not be fired! So when you do your next push (after all the setup), remember to edit a file to somewhat &#8220;force&#8221; a push. Then your content will be checked out by the hook. No update, no deployment*

 [1]: http://blog.ekynoxe.com/2011/10/22/git-post-receive-for-multiple-remote-branches-and-work-trees/ "Git post-receive for multiple remote branches and work-trees"