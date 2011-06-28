--- 
layout: post
title: "30-minute modules: Alias"
created: 1227568651
disqus_id: node/12
category: drupal
---
So often there are very simple tasks that never make it into a proper module.  Today the need arose for one of these tasks and I decided to take the small amount of time to do it right.

The premise was simple.  Have a path on our domain redirect to an external URL.  Simple right.  There are so many ways to do this, and generally I would drop a line in the .htaccess file.  The biggest barrier here is that this requires a trusted developer to edit the .htaccess file.  This resulted in the current way things were being done, which is putting a drupal_goto in a node with the PHP filter.  All was fine... until cron.  When cron tried to run, it would eval this code and redirect to the specified URL.

So I wrote Alias module, while on a conference call.  It took all of about 30 minutes to write it.  About 20 minutes of that was spent on creating the admin interface to create, edit, delete and list the aliases.  In fact, it took longer to figure out a decent name for this module than it did to write it (originally I had named it 'redirect').

Here it is.  Hope you enjoy.

<a href="http://drupal.org/project/alias">Alias project page</a>
