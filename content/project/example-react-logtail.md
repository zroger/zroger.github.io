---
title: "Log tailing w/ React + IntersectionObserver"
date: 2019-05-12T15:12:23-04:00
---

<i class="devicon-github-plain"></i> [zroger/example-react-logtail][1]

This is an example of using the [IntersectionObserver API][2] with React to
dynamically keep an anchor element scrolled into the viewport, if the anchor
was visible before the update. In other words, if the bottom of the logs are
visible, then automatically scroll when new logs come in, but don't scroll if
the user scrolled away from the bottom.

By combining the IntersectionObserver API with a React component, we can track
efficiently monitor the scroll position of an anchor element and keep track of
its visibility in the component's state. When new content is added, we can
decide whether to scroll based only on the component's state.

[1]: https://github.com/zroger/example-react-logtail
[2]: https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API
