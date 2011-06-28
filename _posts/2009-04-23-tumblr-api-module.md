--- 
layout: post
title: Tumblr API Module
created: 1240531735
disqus_id: node/20
category: drupal
---
Today I took over the <a href="http://drupal.org/project/tumblr">Tumblr API</a> module from the <a href="http://drupal.org/user/16496">Jeff Eaton</a>. Jeff had done some initial work on building a pretty solid API to interact with <a href="http://www.tumblr.com/api">Tumblr's API</a>, but never got around to doing any more with it. I did some work that I was going to offer as a patch, but Jeff decided to just let me run with the module.

The work I've done is currently in cvs head. The aim of the development was to create an easy to use API and to use <a href="http://drupal.org/project/feedapi">Feed API</a> to ingest the Tumblr posts. Each type of Tumblr post (regular, link, quote, conversation, photo, audio and video) is formatted similarly to that on Tumblr to create nodes.  Each field is also available to be used by <a href="http://drupal.org/project/feedapi_mapper">Feed Element Mapper</a>.  This is especially cool, since you can put map individual data items to cck fields.
