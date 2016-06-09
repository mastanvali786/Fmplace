class Alert

  wireUpClose: ->
    self = @
    self.elem('.close').click ->
      self.hide()

  init: (elem) ->
    @target = elem
    @wireUpClose()
    @

  elem: (subtarget="") ->
    $("#{@target} .alert #{subtarget}")

  info: (message) ->
    @showMessage "alert-info", message

  error: (message) ->
    @showMessage "alert-error", message

  show: ->
    @elem().fadeIn()

  hide: ->
    @elem().fadeOut()

  showMessage: (type, message) ->
    @elem().addClass(type).find('.content').html(message)
    @show()

window.Alert = Alert