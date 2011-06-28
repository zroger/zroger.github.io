--- 
layout: post
title: Time sensitive data caching
created: 1214970649
disqus_id: node/3
category: drupal
---
I've been working on this rather large project that must make several REST based web service calls for each page generation. Each call can be cached for a different amount of time, ranging anywhere from 1 minute to 1 hour depending on the method being called. So I set out to make sure that the results of all of these calls were being cached for the appropriate amount of time.

This isn't the first time I've used Drupal's caching mechanism. This is, however the first time I have used it where the data was very time-sensitive. The data that can be cached for 1 minute, <strong>MUST</strong> expire after 1 minute. No problem, I thought. There is the expire parameter to cache_set() which accepts a UNIX timestamp. It was easy enough to construct these timestamps and implement them.

<?php
  cache_set($cid, 'cache', serialize($data), time() + $expire);
?>

Now here's the rub. For some reason, I expected these cache entries to be invalidated after the specified time was up. So for an entry that was set with a time + 60 second expire, I would expect to see new results after 60 seconds. It turns out this is not the case.

After looking through the core code, I realized that there is no place where the cache gets invalidated. The only time a cache entry ever gets cleared is through the cache_clear_all function. But I don't want to clear the cache, I just want to expire data that should be expired.

<h3><em>What a misleading function name.</em></h3>

To expire cached data that was set with either CACHE_TEMPORARY or a timestamp as its expires parameter, you must call <a href="http://api.drupal.org/api/function/cache_clear_all/5">cache_clear_all()</a> without a cache id and with the table name.

<?php
  cache_clear_all(NULL, 'cache');
?>

I put this function call in my menu callback function, before trying to retrieve any cache results, and now everything works as expected. Would it be too much trouble to have a convenience function with a better name for this? My suggestion:

<?php
function cache_expire($table) {
  cache_clear_all(NULL,  $table);
}
?>

<h3>See also:</h3>
<ul><li><a href="http://www.lullabot.com/articles/a_beginners_guide_to_caching_data">A beginner's guide to caching data</a> by Jeff Eaton</li></ul>

