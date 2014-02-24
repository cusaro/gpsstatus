# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.filter-heading').click ->
    $('.filter').toggle()


  $("#tag_add").click ->
    $.get $(location).attr('href')+"/tag_add/"+$("input#tag").val()+".js", (data) ->
      data.eval()
    return

  $('.tag[data-id]').click ->
    $.ajax
      url: $(location).attr('href')+"/tag_remove/"+$(this).data('id')+".js"
      type: "DELETE"
      success: (data) ->
        data.eval()