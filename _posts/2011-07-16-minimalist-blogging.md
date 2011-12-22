---
layout: post
title: Minimalist Blogging
category: development
comments: false
published: true
---

My last blog post was on February 4, 2010, almost a year and a half ago.  It's
not that I don't have things to write about, or that I don't want to write. On
the contrary, I really want to write.  Every blogging platform that I've used 
in the past (including various Drupal setups, WordPress, Tumblr, Blogger) has 
been less than ideal.  Many of these are very polished, and for the majority of
bloggers, I'm sure they are more than adequate.  

The problem for me, is that I do at least 95% of my typing in TextMate or a
terminal.  Most of the time this is some sort of development or documentation.
When I'm finished, I save the file and commit to version control.  This is very
comfortable for me.  So why should blogging be any different?

<!-- break -->
So I've spent a little free time over the last couple of weekends migrating my
blog from Drupal to Jekyll.  "Jekyll is a blog-aware, static site generator in 
Ruby", as stated on the Jekyll project page.  How is this better for me as a 
blogger?

1. Posts are written in my editor of choice, in my syntax of choice, just as if
   I were writing code.
2. The source code is the site.  All of my content is in source control.
3. The compiled site is all static files.  There is no database or application
   server.  The site can be served from any web server.

## But what about Drupal?

I love Drupal. It's what I do for a living, and I spend an inordinate amount of
my free time hacking away at Drupal. I build really complex applications for
clients to manage content publishing as part of massive teams.  Drupal is great
in these situations, but for my own blogging needs, I feel it is overkill.  I
also tended to use my Drupal-based blog as a sandbox for tinkering, which meant
my site was in a constant state of disarray.  Not Drupal's fault, but
nonetheless, this did not make for a conducive blogging experience.

## Blogging like a hacker [^1]

So thus commences my experiment in static blogging.  So far, I've really
enjoyed custom crafting the HTML and CSS for the site.  Jekyll's templating is
so similar to building static files, playing with the markup and styling is
very pleasant.  In fact, non-post pages can be created using as much or as 
little help from Jekyll as you want, so completely one-off designs are no
problem.


## Footnotes
[^1]:
  "Blogging like a hacker" is the title of a blog post by Tom Preston-Werner 
  introducing Jekyll. http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html
