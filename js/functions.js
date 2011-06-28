// remap jQuery to $
(function($){

$(window).keypress(function(event) {
  switch(event.which) {
    // b - baseline
    case 98:
      $('body').toggleClass('show-baseline');
      event.preventDefault();
      break;
    default:
      console.log(event.which);
  }
});

})(window.jQuery);