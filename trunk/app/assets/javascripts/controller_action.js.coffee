controller_action = ->
  jQuery ->
    controller = $('body').attr('data-controller')
    action = $('body').attr('data-action')
    if window[controller]
      controller = new window[controller]
      if controller[action]
        controller[action]()
window.controller_action = controller_action