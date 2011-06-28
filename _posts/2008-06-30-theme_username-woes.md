--- 
layout: post
title: theme_username woes
created: 1214865660
disqus_id: node/2
category: drupal
---
I got an email the other day informing me that a blog author on a site I had build could not post comments on his own blog. Authenticated users were not having the same problem, just the blog author. So using devel, I switched to his user account and tried it myself.

<blockquote>"You have to specify a valid author."</blockquote>

So I first dove into the access controls to make sure there wasn't something obvious that I had missed. Nothing. Then I scoured the source code for some mis-behaving form alter or something of the like. Nada. Then I hit google with the exact error message and landed at this <a href="http://drupal.org/node/47308">post</a>, and more specifically, this <a href="http://drupal.org/node/47308#comment-832715">comment</a> by <a href="http://drupal.org/user/227816">rbarnes7</a>.

The problem starts with this bit of code in comment_form():

{% highlight php %}
<?php
function comment_form($edit, $title = NULL) {
  global $user;
  ...
  if ($user->uid) {
    if ($edit['cid'] && user_access('administer comments')) {
      ...
    }
    else {
      $form['_author'] = array('#type' => 'item', '#title' => t('Your name'), '#value' => theme('username', $user)
      );
      $form['author'] = array('#type' => 'value', '#value' => $user->name);
    }
  }
?>
{% endhighlight %}

In my theme I had overridden theme_username to make use of information in the user profile created by bio.module.

{% highlight php %}
<?php
function phptemplate_username($object) {
  if ($object->uid && $object->name) {
    if($nid = bio_for_user($object->uid)){
      $bio = node_load($nid);
      $object->name = $bio->title;
    }

    // Shorten the name when it is too long or it will break many tables.
    if (drupal_strlen($object->name) > 20) {
      $name = drupal_substr($object->name, 0, 15) .'...';
    }
    else {
      $name = $object->name;
    }
    ...
?>
{% endhighlight %}

Only the 4 lines at the top of the function differ from the standard theme_username() function. From what I have seen, this is a pretty standard way to display a profile field (in this case, a bio node title). By simply swapping out the name property with the text that I want, the rest of the function does the rest of the work. And since the $object variable isn't specified to be passed by reference, overwriting the name property won't affect anything else... or so I thought.

The problem lies in the way that php handles global variables. When a variable is declared with the global keyword, it is a reference that you are using. The following are functionally equivalent:

{% highlight php %}
<?php
  global $user;
?>
{% endhighlight %}

and

{% highlight php %}
<?php
  $user = & $GLOBALS['user'];
?>
{% endhighlight %}

So in comment_form(), the call to theme('username', $user) is passing a reference to the global $user object, which means that any changes made to the object in the function take effect in the global scope.

The solution? Simply rewrite phptemplate_username to use a local variable to store the name.

{% highlight php %}
<?php
function phptemplate_username($object) {
  if ($object->uid && $object->name) {
    if($nid = bio_for_user($object->uid)){
      $bio = node_load($nid);
      $name = $bio->title;
    }
    else {
      $name = $object->name;
    }
   
    // Shorten the name when it is too long or it will break many tables.
    if (drupal_strlen($name) > 20) {
      $name = drupal_substr($name, 0, 15) .'...';
    }
    if (user_access('access user profiles')) {
      $output = l($name, 'user/'. $object->uid, array('title' => t('View user profile.')));
    }
    else {
      $output = check_plain($name);
    }
  }
  ...
?>
{% endhighlight %}
