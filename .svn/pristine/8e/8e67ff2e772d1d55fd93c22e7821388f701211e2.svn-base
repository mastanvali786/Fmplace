class Milestone
  wireUpNew: ->

    onUpdate = ->
      $('.milestone-cal').datepick
        showTrigger:'.milestone-cal-icon'
        dateFormat: 'yyyy-mm-dd'
      Util.enforceNumericInput()

    @popup = new Popup("milestone", onUpdate:onUpdate)

  init: ->
    wireUpNew()

window.ProjectActions ||= {}
window.ProjectActions.Milestone = Milestone