--- 
layout: post
title: Operator precedence gets me every time!
created: 1227154778
disqus_id: node/9
category: drupal
---
While working on a module last night, I couldn't figure out why I couldn't get caching to work.  I have done object caching at least a dozen times before but I couldn't figure out why I was not able to get the cached object back. Here's the code I was using:

{% highlight php %}
<?php
  if($cache = cache_get($cid, 'cache') && $cache->data) {
    dsm('Cached!');
    return $cache->data;
  }
?>
{% endhighlight %}

I finally realized that cache_get() was indeed returning a cache object, but the code inside the if statement was never executing.  

Then I saw my mistake.  The && operator has a <a href="http://us.php.net/operators#language.operators.precedence">higher precedence</a> that the = (assignment) operator, so the above statement is similar to this:

{% highlight php %}
<?php
  if($cache = (cache_get($cid, 'cache') && $cache->data)) {
    // ...
  }
?>
{% endhighlight %}

So the solution is simply to wrap the assignment in parenthesis like so:

{% highlight php %}
<?php
  if(($cache = cache_get($cid, 'cache')) && $cache->data) {
    dsm('Cached!');
    return $cache->data;
  }
?>
{% endhighlight %}
