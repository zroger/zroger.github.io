---
layout: default
title: About this site
---

<h6 class="subheader">Behind the curtain</h6>
## About the site

This site is not a Drupal site.  Why not, you ask?  Well, here goes.

* I don't enjoy composing text in a browser.  I write code all day long in
  TextMate, and when I want to write a blog post, I want to do it in the same
  familiar environment.  Jekyll uses only static files to render a site, so I
  never have to leave my editor.
* Since Jekyll uses only static files, my entire site is in version control.
  [Take a look](https://github.com/zroger/zroger.com).
* Not that my site gets a ton of traffic, but my tiny VPS can now handle much
  more traffic since its all static.

### Components

* [__Jekyll__](https://github.com/mojombo/jekyll) <br/>
  Jekyll is a blog-aware, static site generator in Ruby.
* [__normalize.css__](http://necolas.github.com/normalize.css) <br/>
  Much more useful than a typical "reset.css", Normalize.css attempts to make
  the default styles between browsers consistent, and not strip away useful
  defaults.
* [__Jekyll Plugins by Jose Diaz Gonzalez__](https://github.com/josegonzalez/josediazgonzalez.com/tree/master/_plugins) <br />
  Jekyll has a very simple plugin scheme.  I've borrowed and modified several
  from Jose.
* [__LessCSS__](http://lesscss.org/) <br />
  Less CSS makes writing CSS much more enjoyable.  I am using the Less
  [gem](http://rubygems.org/gems/less) along with a Jekyll converter.  The
  converter was first found [here](https://gist.github.com/639920) and then
  modified to work with the current version of the gem (2.0.5).
