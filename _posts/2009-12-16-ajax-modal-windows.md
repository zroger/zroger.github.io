---
layout: post
title: Ajax modal windows, the easy way
category: drupal
tags:
  - ajax
  - ctools
  - dialog
  - drupal
disqus_id: node/31
---

Last week I wrote about the awesomeness that is the <a href="/2009/12/ajax-without-javascript">CTools ajax framework</a>.  If you're anything like me, your mind immediately started racing about all the cool possibilities this opens up.  One of those cool possibilities is yet another hidden <a href="http://drupal.org/project/ctools" title="Chaos Tools project page on Drupal.org">CTools</a> gem, the modal framework.  If you've ever used <a href="http://drupal.org/project/panels" title="Panels project page on Drupal.org">panels</a>, then you've seen CTools modals in action.  In this post, I'll show you how to use modals, in the same way that panels does.

## First things first...

If you missed my last post, chances are that this one will not make any sense.  I highly suggest <a href="/node/30">reading it before continuing with this one</a>.

We will be building a very simple module with two pages.  The first simply holds the link to the modal window, the second is the page that will be displayed in the modal.  Lets start with some basic code to set up our test module.  This is almost identical to the ajax module we built last week.  The biggest difference here, is that the class on the link has been changed to 'ctools-use-modal' and we are adding the javascript using ctools_modal_add_js().

{% highlight php %}
<?php
/**
 * Implementation of hook_menu().
 */
function example_menu() {  
  $items = array();
  $items['test'] = array(
    'title' => 'Ajax Test',
    'page callback' => 'example_test_main',
    'access arguments' => array('access content'),
  );
  $items['test/%ctools_js/go'] = array(
    'page callback' => 'example_test_modal_callback',
    'page arguments' => array(1),
    'access arguments' => array('access content'),
  );
  return $items;
}

/**
 * The main page that holds the link to the modal.
 */
function example_test_main() {
  // Load the modal library and add the modal javascript.
  ctools_include('modal');
  ctools_modal_add_js();

  $output = l('Load modal content', 'test/nojs/go', array(
    'attributes' => array('class' => 'ctools-use-modal')));

  return $output;
}
?>
{% endhighlight %}

All that is left is to define the modal callback.  Since we are using the %ctools_js wildcard, this same callback will be responsible for the content in both modal and non-modal states.  Remember that the %ctools_js wildcard will be translated to a boolean value in which TRUE signals that we are in a javascript context.

{% highlight php %}
<?php
function example_test_modal_callback($js = FALSE) {
  $output = t('<p>Lorem ipsum dolor sit amet...</p>');
  $title = t('Modal example');
  if ($js) {
    ctools_include('ajax');
    ctools_include('modal');
    ctools_modal_render($title, $output);
    // above command will exit().
  }
  else {
    drupal_set_title($title);
    return $output;
  }
}
?>
{% endhighlight %}

The code above is about as simple as it gets with modal windows.  It simply outputs some text and a title in a modal window.  The modal library provides a nice utility function for this, ctools_modal_render().  The function builds the necessary ajax command object and passes it to the browser using ctools_ajax_render().

But now for something not so trivial.  Arguably the best use case for modal windows is for displaying forms.  This is where the modal library really excels.  In this example, we will show the user login form in a modal.  Your first impulse might be to just send the output of <a href="http://api.drupal.org/api/function/drupal_get_form/6" title="drupal_get_form() on api.drupal.org">drupal_get_form()</a> to the modal.  While this would display the form in the modal, it would not handle all of the submission and validation properly.  Normally Drupal form submissions end in a redirect, which would break our ajax callbacks.  Luckily, CTools has an answer for this situation.  In the ajax context, we use ctools_modal_form_wrapper() to build the form.  The one tricky part here, is that we must evaluate the return value of this function.  This function returns an array, that may or may not be populated with ajax commands.  If the form submission was not completed for any reason, such as validation errors, then the array will have the commands needed to re-display the form, with errors, in the modal window.  If the array is empty, then we can assume that the form was submitted properly.  In this case, we add one or more ajax commands to the array to let the user know that the form submitted successfully.  In the case of our login form, we do that by redirecting the user to their account page.

One thing I forgot to mention, is that ctools_modal_form_wrapper() expects you to pass in a form_state array.  drupal_get_form() allows you to pass in additional arguments after the form id, but the ctools form functions expect all arguments to be passed through the form_state array.  In the case of modal forms, the form_state must contain at least an 'ajax' and a 'title' element.

{% highlight php %}
<?php
function example_test_modal_callback($js = FALSE) {
  if ($js) {
    ctools_include('ajax');
    ctools_include('modal');
    $form_state = array(
      'ajax' => TRUE,
      'title' => t('Login'),
    );
    $output = ctools_modal_form_wrapper('user_login', $form_state);
    if (empty($output)) {
      $output[] = ctools_modal_command_loading();
      $output[] = ctools_ajax_command_redirect('user');
    }
    ctools_ajax_render($output);
  }
  else {
    return drupal_get_form('user_login');
  }
}
?>
{% endhighlight %}

Hopefully, I've explained enough so that you can understand what is going on in the above function.

## Dialog API

So here is where I will diverge a little bit.  While using the CTools modals, I kept wishing that I could use the <a href="http://jqueryui.com/demos/dialog/">jQuery UI Dialog widget</a> as the front-end for my modals.  So I took the time to build it.  <a href="http://drupal.org/project/dialog" title="Dialog API project page on Drupal.org">Dialog API</a> aims to be functionally equivalent to the modal library, except that it uses jQuery UI.  The ajax commands that it exposes are all nearly identical to their modal equivalents, except that the display command allows you to pass an array of options to the Dialog widget.  This allows you to control things like height and width from the ajax callback.

And thanks to the insane work of <a href="http://robloach.net/" title="Does this guy ever sleep?">Rob Loach</a>, Dialog API already has a Drupal 7 port.  Very exciting stuff.
