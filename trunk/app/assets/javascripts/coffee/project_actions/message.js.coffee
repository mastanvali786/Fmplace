class Message
  init: ->
   new SharedMessage().init
    resource:"project_message"
    resourceId:"projectid"

window.ProjectActions ||= {}
window.ProjectActions.Message = Message