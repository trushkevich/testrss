window.global = {
  sorry: () ->
    $('.modal').html('Sorry, but something went wrong')
    $('.modal').dialog()
  near_bottom_of_page: () ->
    return $(window).scrollTop() > $(document).height() - $(window).height() - 100;
  delay: (func, ms) -> setTimeout func, ms

}
