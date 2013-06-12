# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.Channel = {
  total_pages: null

  #
  # subscribe/unsubscribe links
  #
  handle_subscribe_links: () ->
    $(".subscribe_link")
      .bind "ajax:success", (e, data, status, xhr) ->
        $(this).parent().find('.unsubscribe_link').show()
        $(this).parent().find('.rename_channel_wrapper').show()
        $(this).hide()
      .bind "ajax:error", (e, xhr, status, error) ->
        global.sorry(xhr.responseText)
    $(".unsubscribe_link")
      .bind "ajax:success", (e, data, status, xhr) ->
        $(this).parent().find('.subscribe_link').show()
        $(this).parent().find('.rename_channel_wrapper').hide()
        $(this).hide()
      .bind "ajax:error", (e, xhr, status, error) ->
        global.sorry()

  #
  # renaming channels
  #
  handle_renaming: () ->
    $('.rename_channel').unbind('click')
    $('.rename_channel').click (event) ->
      form_wrapper = $(this).parent().find('.rename_channel_form_wrapper')
      form_wrapper.toggle()
      form_wrapper.click (event) ->
        event.stopPropagation()
      form_wrapper.find('.close').click (event) ->
        form_wrapper.hide()
      form_wrapper.find('imput[type="submit"]').click (event) ->
        form_wrapper.find('.response').html('')
      form = form_wrapper.find("form")
      channel_id = form.attr('data-channel-id')
      form
        .bind "ajax:success", (e, data, status, xhr) ->
          form.find('input[type="text"]').val('')
          form_wrapper.hide()
          form_wrapper.find('.response').html('')
          $('a[data-channel-id="'+channel_id+'"]').html(data.name)
        .bind "ajax:error", (e, xhr, status, error) ->
          form_wrapper.find('.response').html('Something went wrong, please try again...')
          ###
          errors = $.parseJSON(xhr.responseText)
          error_messages = []
          for field, error of errors
             error_messages.push('<li>' + field + ' ' + error + '</li>')
          form_wrapper.find('.response').html('<ul>' + error_messages.join('') + '</ul>')
          ###
      $('html').click -> 
        $('.rename_channel_form_wrapper').hide()
      event.stopPropagation()
      return false

  #
  # endless scroll
  #
  handle_scroll: () ->
    page = 1
    loading = false
    $(window).scroll ->
      if loading
        return
      if global.near_bottom_of_page() && page < Channel.total_pages
        loading = true
        page++
        path = $('#data_container').attr('data-path-info')
        if /\?/.test(path)
          join = '&'
        else
          join = '?'
        $.ajax path + join + 'page=' + page,
          type: 'get'
          dataType: 'html'
          success: (data, textStatus, xhr) ->
            loading = false
            $("#channels").append("<div class='page'>" + data + "</div>");
            Channel.handle_subscribe_links()
            Channel.handle_renaming()
}

$ ->
  Channel.total_pages = $('#channels').attr('data-num-pages')
  Channel.handle_subscribe_links()
  Channel.handle_renaming()
  Channel.handle_scroll()
