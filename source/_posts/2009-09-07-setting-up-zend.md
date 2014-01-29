---
title: setting-up Zend
author: Matt
layout: post
categories:
  - Zend
tags:
  - Zend
---
Installing the Zend framework on an old Power Mac G5 on Tiger, I ran into a common PHP library problem.

After copying the whole Zend package into my php include folder, trying to use the project creation script gave me the following Manifest error:
<!--more-->

<pre>
  zf.sh create project quickstart<br /> Fatal error: Uncaught exception &#8216;Zend_Tool_Framework_Manifest_Exception&#8217; with message &#8216;A provider provided by the Zend_Tool_Framework_Manifest_ManifestBadProvider does not implement Zend_Tool_Framework_Provider_Interface&#8217; in /usr/local/lib/php/ZendFramework-1.9.2/library/Zend/Tool/Framework/Manifest/Repository.php:100<br /> Stack trace:<br /> #0 /usr/local/lib/php/ZendFramework-1.9.2/library/Zend/Tool/Framework/Loader/Abstract.php(104): Zend_Tool_Framework_Manifest_Repository->addManifest(Object(Zend_Tool_Framework_Manifest_ManifestBadProvider))<br /> #1 /usr/local/lib/php/ZendFramework-1.9.2/library/Zend/Tool/Framework/Client/Abstract.php(118): Zend_Tool_Framework_Loader_Abstract->load()<br /> #2 /usr/local/lib/php/ZendFramework-1.9.2/library/Zend/Tool/Framework/Client/Abstract.php(209): Zend_Tool_Framework_Client_Abstract->initialize()<br /> #3 /usr/local/lib/php/ZendFramework-1.9.2/library/Zend/Tool/Framework/Client/Console.php(96): Zend_Tool_Framework_Client_Abstract->dispatch()<br /> #4 /usr/local/lib/php/ZendFramework-1.9.2/bin/zf.php(214): Zend_Tool_ in /usr/local/lib/php/ZendFramework-1.9.2/library/Zend/Tool/Framework/Manifest/Repository.php on line 100
</pre>

It turned out that the Zend tool was finding the wrong provider in the unit tests directory. I&#8217;m still not sure about what happens, but removing the test folder from the include_path did the trick.

However, I did scratch my head a bit on the following:

<pre>
  Fatal error: Cannot redeclare class Zend_OpenId_Provider in /usr/local/lib/php/ZendFramework-1.9.2/library/Zend/OpenId/Provider.php on line 44
</pre>

After a bit of searching, I discovered two things:

*   Don&#8217;t put the Zend framework package directory in any subdirectory of your document root or it will be picked up as well
*   Clean your server from any other Zend libraries before trying to use a new one! Seems obvious enough, but when you are appointed a machine with lots of &#8216;history&#8217; (let&#8217;s keep it that way), you can&#8217;t always do what you want&#8230;

Zend has now been installed, but I am still not really happy about having to separate the whole framework directory (eg, removing the test directory) in order to have things working.
Anyone has an update on this?

**Edit &#8211; Setting up the environment variable ZEND\_TOOL\_INCLUDE_PATH to the proper library on the server solves this as well. In particular, the first finding above is not valid anymore, but it doesn&#8217;t prevent you from doing a bit of house cleaning anyways ;)**