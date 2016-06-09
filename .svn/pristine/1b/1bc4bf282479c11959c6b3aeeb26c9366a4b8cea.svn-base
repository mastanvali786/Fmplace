class ProjectsAction
  updatePopup: (data) ->
    self = @
    container = $('#popup-container').html(data.content)
    $('.submit-popup').click ->
      $('#popup-form').submit()
      $('#loading_spinner').show()
    $('#popup-form').on 'ajax:success', (event, response) ->
      self.updatePopup response
      $('#popup-container').hide()
      Util.page.refresh()
      $('#loading_spinner').hide()
      if $(event.target).attr('class') == 'new_milestone'
        alert("Milestone was created successfully.")
      else
        alert("Milestone was updated successfully.")
      $('#popup-form #cancel').attr('data-reload', true)
    $('#popup-form').on 'ajax:error', (event, response) ->
      $('#loading_spinner').hide();
      self.updatePopup response.responseJSON
    $('.hide-popup').click self.hidePopup
    $('.milestone-cal').datepick
      showTrigger:'.milestone-cal-icon'
      dateFormat: 'yyyy-mm-dd'
    Util.enforceNumericInput()
    container

  showNewPopup: (projectId) ->
    self = @
    $.get(
      "/milestones/popup/new"
      project_id:projectId
      (data) ->
        self.updatePopup(data).fadeIn("slow")
    )

  showPopup: (milestoneId) ->
    self = @
    $.get(
      "/milestones/#{milestoneId|0}/popup"
      (data) ->
        self.updatePopup(data).fadeIn("slow")
    )
  hidePopup: ->
    if $(this).data('reload')
      Util.page.refresh()
    else
      $('#popup-container').empty().fadeOut("slow")

  milestone: ->
    self = @
    $('.show-new-popup').click ->
      projectId = $(this).data('projectid')
      self.showNewPopup projectId

    $('.show-popup').click ->
      milestoneId = $(this).data('milestoneid')
      self.showPopup milestoneId


window["Projects::Action"] = ProjectsAction