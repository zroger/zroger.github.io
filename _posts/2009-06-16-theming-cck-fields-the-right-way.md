---
layout: post
title: Theming cck fields, the "right way"
created: 1245202455
disqus_id: node/25
category: blog
tags: drupal
---
So that title may be a little ambitious, but this is how I like to theme CCK fields, and (at least in my mind) its the most flexible and Drupal-like way.

## Problem:

I have a multi-value node reference field that I've added to almost every content type on a site, so that any post may contain a hand-crafted list of related topics. The problem lies in that I want something different than the standard CCK nodereference markup. This could easily be done in the node.tpl.php file, but not all content types have this field, and the code would need to be replicated in every content type which has that field.

<figure>
  <img src="http://img.skitch.com/20090617-rqp6dtcrup24gcfwxiipp4mksd.jpg" alt="" />
  <figcaption>Typical CCK markup</figcaption>
</figure>

## Solution:

What I want to theme is the field container. Not the whole node, not the individual field values, but the group of field values as a piece of any node. Luckily the Theme Developer module came in handy. I noticed that each CCK field is based on content-field.tpl.php, and could use a more specific template to theme an individual field. This works across content types, so theming the field once will work regardless of the content type that the field is attached to.

<figure>
  <img src="http://img.skitch.com/20090617-t68gg6da9rbscei6sfbkf5y8um.jpg" alt="" />
  <figcaption>Template suggestions for content-field.tpl.php</figcaption>
</figure>

I started out by copying content-field.tpl.php from cck/theme folder to my theme folder. This file must be in the theme folder, otherwise Drupal will not find any template files derived from it. Then I made a copy of content-field.tpl.php and name d it content-field-field_related_posts.tpl.php, where field_related_posts is the name of the field I am theming.

<figure>
  <img src="http://img.skitch.com/20090617-8idjqugbcs7uwwdiieuubet2fx.jpg" alt="" width="405" height="226" />
  <figcaption>Theme directory with content-field.tpl.php and overrides.</figcaption>
</figure>

And now the fun part. The code.

<pre class="prettyprint linenums"><code class="language-php">
&lt;?php
// $Id: content-field.tpl.php,v 1.1.2.5 2008/11/03 12:46:27 yched Exp $

/**
 * @file content-field.tpl.php
 * Default theme implementation to display the value of a field.
 *
 * Available variables:
 * - $node: The node object.
 * - $field: The field array.
 * - $items: An array of values for each item in the field array.
 * - $teaser: Whether this is displayed as a teaser.
 * - $page: Whether this is displayed as a page.
 * - $field_name: The field name.
 * - $field_type: The field type.
 * - $field_name_css: The css-compatible field name.
 * - $field_type_css: The css-compatible field type.
 * - $label: The item label.
 * - $label_display: Position of label display, inline, above, or hidden.
 * - $field_empty: Whether the field has any valid value.
 *
 * Each $item in $items contains:
 * - 'view' - the themed view for that item
 *
 * @see template_preprocess_field()
 */

  if (!$field_empty) {
    // build a simple array of items
    $list_items = array();
    foreach ($items as $delta => $item) {
      if (!$item['empty']) {
        $list_items[] = $item['view'];
      }
    }

    switch ($label_display) {
      case 'above':
        print theme('item_list', $list_items, t($label));
        break;

      case 'inline':
        print '&lt;div>&lt;strong>'. t($label) .':&lt;/strong> '. join(', ', $list_items) .'&lt;/div>';
        break;

      case 'hidden':
      default:
        print theme('item_list', $list_items);
        break;

    }
  }
</code></pre>
<div class="caption">content-field-field_related_posts.tpl.php</div>

There are a couple of variables that I should explain, but as you can see, there is a ton of documentation already in this file, since it was copied from content-field.tpl.php. The first variable used is $field_empty. I don't want anything output if there is nothing in the field, so I wrap the whole thing in an if statement. Then I loop over the $items array. Each of the items in the $items array is itself an array, with an 'empty' index and a 'view' index. Basically, if its not empty, I add the view to a simple array, essentially collapsing the more complicated $items array. Then, I do a switch on the $label_display variable, to determine how to output the new array I've created.

<figure>
  <img src="http://img.skitch.com/20090617-pw469xf6tm828jruisid8f49jr.jpg" alt="" width="430" height="430" />
  <figcaption>Label options for CCK fields</figcaption>
</figure>

$label_display hold one of three values, 'above', 'inline' or 'hidden'. This value is chosen on the Display Fields tab of each content type in the Content Type administration section. Since I'm using CCK's built in UI, this field remains tied to the decisions made in the admin interface. For this particular implementation, I am display the items in a Drupal "item_list" when the label display is set to "above" or "hidden", but displaying the items as a comma separated list with an inline label when set to "inline".

This is just one example of what can be done with content field templates. You could also build different outputs based on the $teaser or $page variables which are also available to you.
