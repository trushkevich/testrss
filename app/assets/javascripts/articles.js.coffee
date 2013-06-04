# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  sorry = () ->
    $('.modal').html('Sorry, but something went wrong')
    $('.modal').dialog()

  nearBottomOfPage = () ->
    return $(window).scrollTop() > $(document).height() - $(window).height() - 100;

  #
  # add to/remove from favourites
  #

  handle_stars = () ->
    $(".add_to_favourites_link")
      .bind "ajax:success", (e, data, status, xhr) ->
        $(this).parent().find('.remove_from_favourites_link').show()
        $(this).hide()
      .bind "ajax:error", (e, xhr, status, error) ->
        sorry()
    $(".remove_from_favourites_link")
      .bind "ajax:success", (e, data, status, xhr) ->
        $(this).parent().find('.add_to_favourites_link').show()
        $(this).hide()
      .bind "ajax:error", (e, xhr, status, error) ->
        sorry()

  handle_stars()

  #
  # endless scroll
  #

  page = 1
  total_pages = $('#articles').attr('data-num-pages')
  loading = false

  $(window).scroll ->

    if loading
      return

    if nearBottomOfPage() && page < total_pages
      loading = true
      page++
      $.ajax $('#data_container').attr('data-path-info') + '?page=' + page,
        type: 'get'
        dataType: 'html'
        success: (data, textStatus, xhr) ->
          loading = false
          $("#articles").append("<div class='page'>" + data + "</div>");
          handle_stars()
