;((function($){
  $(window).load(function() {
    
    // Remove empty first line from code samples before prettyPrint.
    $(".prettyprint > code").each(function() {
      $(this).html($(this).html().replace(/^\n/, ''));
    });

    window.prettyPrint && prettyPrint();
  });  
})(jQuery));
