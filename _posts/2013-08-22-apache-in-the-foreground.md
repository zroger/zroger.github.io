---
layout: post
published: true
title: Running Apache in the foreground
category: featured
---

Lately I've been giving a lot of thought to my local development environment.
When I have a new Drupal project to start, I usually start by creating a new
hosts file entry and adding an apache virtual host for the project. *But why?*
I don't do this when I start a new ruby project.  Whether it's Rails or Jekyll,
I just start a webserver right from the project root, and when I'm done with it,
<kbd>ctrl+c</kbd> and it goes away.  **I want this for my Drupal and PHP projects.**

So here's what I figured I would need to do:

* Run apache in the foreground from the project root.
* Craft a minimal apache configuration file for serving PHP from a single doc root.
* Extra credit: get apache to log to the console in the foreground.

### Step 1: Run apache in the foreground

This is the full command I'll be using to run apache from the current directory.

{% highlight console %}
$ apachectl -d . -f httpd.conf -e info -DFOREGROUND
{% endhighlight %}

* `-d .` sets the ServerRoot to the current directory.  All relative paths
  within the configuration file will resolve to this root.
* `-f httpd.conf` sets the configuration file to use.  Note that this is relative
  to the ServerRoot, not the current working directory.  In this case, the
  ServerRoot is the current working directory, so httpd.conf needs to exist in
  the current working directory.
* `-e info` sets the logging level for startup.  This is different than the log
  level set in the configuration file.
* `-DFOREGROUND` defines the special apache directive that will cause the parent
  process to run in the foreground and not detach from the shell.

### Step 2: Minimal httpd.conf

Now to get started on a minimal `httpd.conf`.  Here's the whole file.  I'll go
through it line by line below.

{% highlight apache linenos %}
ServerName localhost
Listen 8080
PidFile tmp/httpd.pid
LockFile tmp/accept.lock

LoadModule authz_host_module /usr/libexec/apache2/mod_authz_host.so
LoadModule dir_module /usr/libexec/apache2/mod_dir.so
LoadModule mime_module /usr/libexec/apache2/mod_mime.so
LoadModule log_config_module /usr/libexec/apache2/mod_log_config.so
LoadModule rewrite_module /usr/libexec/apache2/mod_rewrite.so
LoadModule php5_module /usr/local/opt/php53/libexec/apache2/libphp5.so

LogLevel info
ErrorLog "|cat"
LogFormat "%h %l %u %t \"%r\" %>s %b" common
CustomLog "|cat" common

DocumentRoot "build/html"
<Directory "build/html">
  AllowOverride all
  Order allow,deny
  Allow from all
</Directory>

AddType application/x-httpd-php .php
DirectoryIndex index.html index.php
{% endhighlight %}

First things first.  Set the ServerName to localhost, listen on port 8080 and
stash the pid and lock files in ./tmp.  Apache will not create the tmp directory,
so either make sure this directory exists or choose another location.

Next we need to enable a minimal set of modules.

* `mod_authz_host` provides the `allow`, `deny` and `order` directives.
* `mod_dir` provides the `DirectoryIndex` directive.
* `mod_mime` provides automatic mime content type headers.
* `mod\_log\_config` provides the `CustomLog` and `LogFormat` directives.
* `mod\_rewrite` and `mod\_php` are application specific, so leave them out if
  you don't need them.

To get the logs printed to the console, we use Apache's
[piped log](http://httpd.apache.org/docs/2.2/logs.html#piped) format to pipe the
log output to `cat`, which will print all of the logs to the console instead of
stashing them in a file.

Finally, we set up the DocumentRoot.  My project is built into `build/html` so
that's what I'm using here.  Change this to whatever suits your project.  Since
this is only ever intended for local development, the Directory is set up to be
extremely permissive.

I also added basic PHP handling, but again, if you don't
need PHP, there's no reason to add these lines.

### Final thoughts

1. This solution requires creating an httpd.conf for every project, so it's not
as turnkey as something like Jekyll or Rails.  I'm experimenting with a project
I'm calling Feather to wrap this process into something nicer which can be
included with Composer.

2. At the time, I'm still primarily running PHP 5.3 to match the production
version of some projects.  I'll be investigating the use of PHP 5.4's built-in
webserver at some point.  Nonetheless, it's still nice to have full use of
Apache in my local environment, especially for projects like Drupal that make
use of a `.htaccess` file.
