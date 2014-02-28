# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.filter-heading').click ->
    $('.filter').toggle()

  #TODO rewrite this
  $("#tag_add").click ->
    $.ajax
      url: $(this).data('url')
      type: "PUT"
      data: {tag: $("#tag").val()}
      success:  ->

  $('.tag[data-id]').click ->
    $.ajax
      url: $(this).data('url')
      type: "DELETE"
      data: {tag: $(this).data('id')}
      success: (data) ->
