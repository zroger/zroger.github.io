---
layout: post
title: Drupal theme and module naming conflicts
categories:
  - development
  - drupal
  - theming
disqus_id: node/28
category: blog
tags: drupal
---

Andrew was having a problem earlier today with a theme's preprocess function not being called in the order he expected.  In particular, this function was a THEMENAME_preprocess_node() function.  The odd thing was, that when he looked at the theme registry using the handy devel module, the order of preprocess functions was:

1. THEMENAME_preprocess_node()
2. views_preprocess_node()
3. phptemplate_preprocess_node()

The phptemplate_preprocess_node function is found in the base theme, so that didn't look out of place.  I then realized that the themes preprocess function was being called amongst a bunch of module preprocess functions.  That's when the light bulb went off in my head.

It turns out that there was also a module with the same name as the theme. Since php has only a single namespace, THEMENAME_preprocess_node() was interpreted as MODULENAME_preprocess_node(). Yikes!!!

Let's get this fixed in Drupal 7. There is already an <a href="http://drupal.org/node/371375">issue</a> in the Drupal issue queue to handle these naming conflicts.