---
layout: default
permalink: index.html
---

My personal jekyll starter repo.

Features
---

- Compatible with [Jekyll on Github Pages](https://help.github.com/articles/using-jekyll-with-pages) without committing the rendered site.
- [Zurb Foundation 4](http://foundation.zurb.com/docs/sass.html) support with SASS.
- [Pygments syntax highlighting](http://jekyllrb.com/docs/templates/#code_snippet_highlighting) with [Solarized](http://ethanschoonover.com/solarized) (both Light and Dark styles).
- Inspection of liquid variables in the javascript console.
- Procfile for easy development workflow.
- Dependency management w/ bundler.

Procfile
---

This repo comes with a Procfile that runs both jekyll and compass, making it
simple to develop and test the site.  Compass watches for changes to the SASS
files, and Jekyll watches everything else.

To start the development server run:

    bundle exec foreman start

Then just `ctrl+c` to stop it.

Zurb Foundation 4
---

Foundation styles are included using the zurb-foundation gem and sass. The
relevant source files are located in the _sass directory.

- _normalize.scss - Imported from app.scss, unmodified.
- _settings.default.scss - Copy of unmodified _settings.scss from Foundation.
  This file is imported by _settings.scss for the functions defined in it.
  Leave this file unmodified.
- _settings.scss - Put settings overrides in this file.
- _solarized.scss - Defines variables for each of the solarized colors.
- _pygments.scss - Defines a mixin to generate pygments styles with solarized colors.
- app.scss - This is the file that pulls it all together.  Site styles can be
  defined in this file.

The Procfile takes care of rendering the css files to the assets directory.  The
generated CSS files must be checked into version control, since Github Pages
can't generate them.

Pygments + Solarized
---

Include variables for solarized colors at any point using `@import 'solarized';`.
The color names are all prefixed with `solarized-` so the variables are like
`$solarized-base03` and `$solarized-cyan`.

A mixin is provided for easily creating pygments styles for either solarized
light or solarized dark.  The included app.scss uses this mixin to provide
default syntax highlighting using the dark style, and a trigger for the light
style by adding `.syntax-inverse` to any containing element (e.g. the body tag).

Variable inspection
---

When creating new layouts or pages in Jekyll, it is very useful to inspect the
`site` and `page` variables.  This repo includes a json filter for liquid
variables.  The master layout will output these variable to the javascript
console using this filter so that you can inspect these variables at any time.

<p class="text-center">
    <img src="https://dl.dropboxusercontent.com/u/1477376/jekyll-starter-images/liquid-variables.png">
</p>

Keep in mind that this will not work on Github Pages since custom plugins are
not allowed.  For this reason, logging to the javascript console is only
enabled when jekyll is running in watch mode.

