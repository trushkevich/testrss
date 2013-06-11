# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  form = $('#search_form')
  submit = form.find('input[type="submit"]')
  search_field = form.find('input[type="text"]')
  submit.bind('click', (event) ->
    if !search_field.val()
      return false
  )
  
  bind_ajax_callbacks(form)


bind_ajax_callbacks = (elements) ->
  elements.each () ->
    $(this)
      .bind "ajax:success", (e, data, status, xhr) ->
        console.log(data)
        if !data.channels.length && !data.articles.length
          $('#channels_wrapper, #articles_wrapper').html('')
          $('.found_channels, .found_articles').hide()
          $('.nothing_found').show()

        if data.channels.length
          $('.found_channels').show()
          $('#channels_wrapper').html(data.channels_pagination+data.channels+data.channels_pagination)
        else
          $('.found_channels').hide()
          $('#channels_wrapper').html('')

        if data.articles.length
          $('.found_articles').show()
          $('#articles_wrapper').html(data.articles_pagination+data.articles+data.articles_pagination)
        else
          $('.found_articles').hide()
          $('#articles_wrapper').html('')

        pagination_links = $('.pagination a')
        bind_pagination_callbacks(pagination_links)

      .bind "ajax:error", (e, xhr, status, error) ->
        global.sorry()


bind_pagination_callbacks = (elements) ->
  elements.each () ->
    $(this)
      .bind "ajax:success", (e, data, status, xhr) ->
        if data.channels != undefined
          $('#channels_wrapper').html(data.channels_pagination+data.channels+data.channels_pagination)
          $('html, body').scrollTo('.found_channels', 250)

        if data.articles != undefined
          $('#articles_wrapper').html(data.articles_pagination+data.articles+data.articles_pagination)
          $('html, body').scrollTo('.found_articles', 250)

        pagination_links = $('.pagination a')
        bind_pagination_callbacks(pagination_links)

      .bind "ajax:error", (e, xhr, status, error) ->
        global.sorry()
