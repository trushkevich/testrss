# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

Search = {
  form: null
  #
  # Submit pressed. Don't allow to search by empty string
  #
  handle_submit: () ->  
    submit = Search.form.find('input[type="submit"]')
    search_field = Search.form.find('input[type="text"]')
    submit.bind('click', (event) ->
      if !search_field.val()
        return false
    )

  #
  # Handling form ajax
  #
  bind_ajax_callbacks: (elements) ->
    elements.each () ->
      $(this)
        .bind "ajax:success", (e, data, status, xhr) ->
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

          Search.reinit_links($('.pagination a'))

        .bind "ajax:error", (e, xhr, status, error) ->
          global.sorry()


  #
  # Handling pagination ajax
  #
  bind_pagination_callbacks: (elements) ->
    elements.each () ->
      $(this)
        .bind "ajax:success", (e, data, status, xhr) ->
          if data.channels != undefined
            $('#channels_wrapper').html(data.channels_pagination+data.channels+data.channels_pagination)
            $('html, body').scrollTo('.found_channels', 250)

          if data.articles != undefined
            $('#articles_wrapper').html(data.articles_pagination+data.articles+data.articles_pagination)
            $('html, body').scrollTo('.found_articles', 250)

          Search.reinit_links($('.pagination a'))

        .bind "ajax:error", (e, xhr, status, error) ->
          global.sorry()

  #
  # Handling newly added pagination links, channels and articles
  #
  reinit_links: (elements) ->
    Search.bind_pagination_callbacks(elements)
    Channel.handle_subscribe_links()
    Channel.handle_renaming()
    Article.handle_stars()
    Article.handle_comments()

}

$ ->
  Search.form = $('#search_form')
  Search.handle_submit()  
  Search.bind_ajax_callbacks(Search.form)


