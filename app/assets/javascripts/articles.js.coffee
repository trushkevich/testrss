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
          $("#articles").append("<div class='page'>" + data + "</div>")
          handle_stars()


  #
  # adding comments
  #

  handle_comments = () ->
    $('.add_comment_link').click (event) ->
      article_wrapper = $(this).parent().parent().parent()
      article_id = article_wrapper.attr('data-article-id')
      form_wrapper = $('.add_article_comment_form_wrapper[data-article-id="'+article_id+'"]')
      form = form_wrapper.find('form')
      cancel = form.find('button')
      cancel.click (event) ->
        form_wrapper.slideUp(100)
        form.find('input[type="text"], textarea').val('')
      form_wrapper.slideDown(100)
      comments = article_wrapper.find('.comments')
      comments_count = article_wrapper.find('.comments_count')
      form
        .bind "ajax:success", (e, data, status, xhr) ->
          comments.html(data.comments)
          comments_count.html(data.count)
          form.find('input[type="text"], textarea').val('')
          form_wrapper.slideUp(100)
        .bind "ajax:error", (e, xhr, status, error) ->
          sorry()
      event.stopPropagation()
      return false

    # toggle with 2 functions is not working properly so using this workaround
    # TODO: use toggle
    comments_open = false
    $('.show_comments').click ->
      article_wrapper = $(this).parent().parent().parent()
      comments = article_wrapper.find('.comments')
      if(!comments_open)
        comments.slideDown(100)
        $(this).html('Hide comments')
        comments_open = true
      else
        comments.slideUp(100)
        $(this).html('Show comments')
        comments_open = false
      event.stopPropagation()
      return false
  
  handle_comments()

