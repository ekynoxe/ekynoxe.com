---
title: Mastermind
author: Matt
layout: post
categories:
  - javascript
tags:
  - javascript
---
Latest fun tiny project: creating a small mastermind game in javascript in less than 1k for <http://js1k.com/>.

<p class="attachement"><a href="http://mastermind.ekynoxe.com" title="play mastermind"><img src="http://blog.ekynoxe.com/wp-content/uploads/2010/08/mastermind.jpg" alt="mastermind" /></a></p>

Play here: <http://mastermind.ekynoxe.com/> or download it from [github][1] and run it offline!

Rules are simple:

Guess by submitting with your keyboard numbers from 0-9
After pressing 4 digits the guess is automatically submitted
The result shows symbols:
* no symbol means no digit is in the code to guess
* a &#8216;-&#8217; means one of the digits is in the code to guess, but not at the correct place
* a &#8216;+&#8217; means one of the digits is in the code to guess, AND at the correct place
If a digit exists twice in the code to guess, symbols do not represent it, you will have
to get it by yourself!
An alert is displayed when the code is found, and the game reset

 [1]: http://github.com/ekynoxe/Mastermind