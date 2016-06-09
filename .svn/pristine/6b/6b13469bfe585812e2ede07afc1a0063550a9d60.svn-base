class Message
  index: ->
    onUpdate = ->
      new FormValidator().init()

    new SharedMessage().init
      resource:"message"
      popup:
        onUpdate: onUpdate

window.Message = Message