# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  sorry = () ->
    $('.modal').html('Sorry, but something went wrong')
    $('.modal').dialog()

  form_wrapper = $('#new_subscription_form_wrapper')

  $('#add_subscription').click (event) ->
    form_wrapper.toggle()
    event.stopPropagation()

  $('html').click -> 
    form_wrapper.hide()

  form_wrapper.click (event) ->
    event.stopPropagation()

  form_wrapper.find('.close').click (event) ->
    form_wrapper.hide()

  form_wrapper.find('imput[type="submit"]').click (event) ->
    form_wrapper.find('.response').html('')
    
  $("#new_subscription_form")
    .bind "ajax:success", (e, data, status, xhr) ->
      $('#new_subscription_form input[type="text"]').val('')
      form_wrapper.hide()
      form_wrapper.find('.response').html('')
      $('#main').html(data)
    .bind "ajax:error", (e, xhr, status, error) ->
      form_wrapper.find('.response').html('Something went wrong, please try again...')
      ###
      errors = $.parseJSON(xhr.responseText)
      error_messages = []
      for field, error of errors
         error_messages.push('<li>' + field + ' ' + error + '</li>')
      form_wrapper.find('.response').html('<ul>' + error_messages.join('') + '</ul>')
      ###
