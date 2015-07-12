$ ->
  $('.toggle-table').click (el) ->
    $table = $(el.target).next('.collapse')
    $table.collapse('toggle')
