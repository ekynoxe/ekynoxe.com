---
title: Git post-receive for multiple remote branches and work-trees
author: Matt
layout: post
categories:
  - git
tags:
  - git
---
A while ago I set up my server to automatically deploy new content from my git repositories when changes where pushed to them. This automatic workflow is great and fairly simple to setup, but I recently needed to add a twist to it: what if I want to deploy separate remote branches to their own individual work-trees? Here&#8217;s how&#8230;

<p class="attachement"><span><img src="{{ "gitflow.png" | image_path | cdn }}" alt="Gitflow" /></span></p>

<!--more-->


Below is a walkthrough of my findings along the way of debugging the initial implementation, but if you&#8217;re in a hurry, you can go straight to [the solution][1]

## Initial, single remote branch setup

The initial setup has been explained here before, so you only have to follow [these basic instructions][2] to get yourself going on a single master branch auto-deployment.

## More branches, more work-trees please!

Right, now let&#8217;s say you want not only the master branch of your code to be deployed to a live website, but you also want the development branch to be deployed to it&#8217;s own web root directory so you can test a development version of your site (and potentially f** it all up) while the live site still runs the last &#8220;gold&#8221; version of your code. You will undoubtedly have several local branches, several corresponding tracking remote branches. For this setup, you will also need several corresponding work-trees, all with their automated deployments upon pushing to the main repository.

Unsurprisingly, there is very little to change to our method explained in the [previous setup][3], but the basic instructions I found did not initially work on my Ubuntu server, so you&#8217;ll have to be aware of a few things.

### Initial findings

Dylan over dylanserver.com posted this <a title="Git post-receive hook for live branch" href="http://dylansserver.com/note/git_post-receive_hook/" target="_blank">handy bit of code</a> earlier this year:

<pre>
  if ! [ -t 0 ]; then
    read -a ref
  fi

  IFS='/' read -ra REF <<< "${ref[2]}"

  branch="${REF[2]}"

  if [ "live" == "$branch" ]; then
    git --work-tree=/var/www/dylanstestserver.com/ --git-dir=.. checkout -f
    echo 'Changes pushed live.'
  fi
</pre>

If you read carefully the post, you can notice that the checkout command is still there, but augmented with the --work-tree and --git-dir arguments.

Great! Thats a great starting point, firing up vi on my remote server, I edited my 'post-receive' hook and pasted the following code in it (after changing the branch name to "dev" instead of "live" to test only with my dev site). Note that I had also added the shebang at the top of the file...

<pre>
  #!bin/sh
  if ! [ -t 0 ]; then
    read -a ref
  fi

  IFS='/' read -ra REF <<< "${ref[2]}"

  branch="${REF[2]}"

  if [ "dev" == "$branch" ]; then
    git --work-tree=/path/under/root/dir/dev-site/ --git-dir=.. checkout -f
    echo 'Changes pushed dev.'
  fi
</pre>

The next git push executed the hook but I got the following error in the git push output:

<pre>read: 4: Illegal option -a</pre>

### The right shebang

The problem was that the shebang I added uses sh, which, according to some <a href="http://stackoverflow.com/questions/2462317/bash-syntax-error-redirection-unexpected/2462357#2462357" title="Bash: Syntax error: redirection unexpected" target="_blank">stackoverflow answers</a> doesn't use bash on ubuntu (my server). Incidentally, I found this out after fiddling around with the read command and removing the -a option, only to find out that an "unexpected redirect" has been found.

The solution was simple: change the shebang to:

<pre>#!bin/bash</pre>

Now, that hook was going to checkout my dev branch into my development site's root directory... err... Not quite yet.

### The right git directory

The next error I encountered was:

<pre>fatal: Not a git repository: '..'</pre>

That's from the script itself, but I can't understand why this was failing, as --git-dir should accept absolute or relative directories. However, the GIT_DIR environment variable should be set to the current directory, which during the push, is the git directory. So I elected to remove the option altogether:

<pre>
  #!bin/sh
  if ! [ -t 0 ]; then
    read -a ref
  fi

  IFS='/' read -ra REF <<< "${ref[2]}"

  branch="${REF[2]}"

  if [ "dev" == "$branch" ]; then
    git --work-tree=/path/under/root/dir/dev-site/ checkout -f
    echo 'Changes pushed dev.'
  fi
</pre>

Now the push didn't report any error, and "some" code to the correct development website root directory! Yay!
BUT... That code was the MASTER branch's code. Not the DEV branch.

<a id="rightsol"></a>

## The right solution

As all we are doing in the hook is performing a git checkout (with some options), we can simply pass the branch we want to checkout as a parameter and all works well!
I'm yet to understand what environment variables are set and used by the hook, but for the moment, my final post-receive hook looks like this:

**Edit - Thanks to Peter and his comments below, the script below now works while pushing multiple branches at once! Thanks to him!**

<pre>
  #!/bin/bash

  while read oldrev newrev ref
  do
    branch=`echo $ref | cut -d/ -f3`

    if [ "master" == "$branch" ]; then
      git --work-tree=/path/under/root/dir/live-site/ checkout -f $branch
      echo 'Changes pushed live.'
    fi

    if [ "dev" == "$branch" ]; then
      git --work-tree=/path/under/root/dir/dev-site/ checkout -f $branch
      echo 'Changes pushed to dev.'
    fi
  done
</pre>

You will notice I have added the master branch in there too, and you can expand the script with whatever branch you want to checkout, along with the correct work-tree.

 [1]: #rightsol
 [2]: /automated-deployment-on-remote-server-with-git/ "automated deployment on remote server with git"
 [3]: /automated-deployment-on-remote-server-with-git/ "Automated deployment on remote server with git"