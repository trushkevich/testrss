# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  page = 1
  total_pages = $('#channels').attr('data-num-pages')
  loading = false

  nearBottomOfPage = () ->
    return $(window).scrollTop() > $(document).height() - $(window).height() - 100;

  sorry = () ->
    $('.modal').html('Sorry, but something went wrong')
    $('.modal').dialog()


  handle_subscribe_links = () ->
    $(".subscribe_link")
      .bind "ajax:success", (e, data, status, xhr) ->
        $(this).parent().find('.unsubscribe_link').show()
        $(this).hide()
      .bind "ajax:error", (e, xhr, status, error) ->
        sorry()
    $(".unsubscribe_link")
      .bind "ajax:success", (e, data, status, xhr) ->
        $(this).parent().find('.subscribe_link').show()
        $(this).hide()
      .bind "ajax:error", (e, xhr, status, error) ->
        sorry()

  handle_subscribe_links()

  $(window).scroll ->

    if loading
      return

    if nearBottomOfPage() && page < total_pages
      loading = true
      page++
      $.ajax '/channels?page=' + page,
        type: 'get'
        dataType: 'html'
        success: (data, textStatus, xhr) ->
          loading = false
          $("#channels").append("<div class='page'>" + data + "</div>");
          handle_subscribe_links()
