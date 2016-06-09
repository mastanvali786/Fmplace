class Popup

  onUpdate: undefined
  resource: undefined

  updatePopup: (data) ->
    self = @
    container = $('#popup-container').html(data.content)
    $('.submit-popup').click (e) ->
      $('#popup-form').submit()
    $('#popup-form').on 'ajax:success', (event, response) ->
      self.updatePopup response
      error_message = $('#error_explanation li').val()
      if error_message != 0
        $('#popup-container').hide()
        alert("Message was sent successfully.")
        Util.page.refresh()
      $('#popup-form #cancel').attr('data-reload', true)
    $('#popup-form').on 'ajax:error', (event, response) ->
      self.updatePopup response.responseJSON
    $('.hide-popup').click self.hidePopup
    self.onUpdate() if self.onUpdate
    container

  showNewPopup: (projectId) ->
    self = @
    $.get(
      "/#{self.resource}s/popup/new"
      project_id:projectId
      (data) ->
        self.updatePopup(data).fadeIn("slow")
    )

  showPopup: (resourceId) ->
    self = @
    $.get(
      "/#{resource}/#{resourceId|0}/popup"
      (data) ->
        self.updatePopup(data).fadeIn("slow")
    )

  hidePopup: ->
    if $(this).data('reload')
      Util.page.refresh()
    else
      $('#popup-container').empty().fadeOut("slow")

  constructor: (resource, options={}) ->
    @resource = resource
    @onUpdate = options.onUpdate if options.onUpdate

  init: ->
    self = @
    $('.show-new-popup').click ->
      projectId = $(this).data('projectid')
      self.showNewPopup projectId

  $('.show-popup').click ->
    resourceId = $(this).data("#{self.resource}id")
    resource_2 = $(".overlap_popuup").show();
    self.showPopup resourceId


window.Popup = Popup