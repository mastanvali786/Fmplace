class SharedMessage
  resource: undefined
  save_delete: (type, elem) ->
    self = @
    $.ajax(
      "/#{self.resource}s/#{type}"
      type: 'PUT'
      dataType: "json"
      data:
        project_id: $(elem).data('resourceId')
        messageIds: self.selected().ids()
      success: (data) ->
        Util.page.refresh()
    )

  wireUpSave: ->
    self = @
    $('#message-save').click ->
      self.save_delete "save", @

  wireUpFilter: ->
    self = @
    val = $('#message_filter').data('filter')
    $('#message_filter').val(val) if val
    resourceId= $('#message_filter').data('resourceid') if self.resourceId
    $('#message_filter').change ->
      new_val = $('#message_filter').val()
      resource = ""
      resource = "id=#{resourceId}&" if self.resourceId
      window.location.href="?#{resource}filter=#{new_val}"

  selected: ->
    _selected = $('input.selected:checked')
    length: _selected.length
    ids: ->
      $.map(_selected, (elem) ->
        $(elem).data('messageid')
      )
  wireUpDelete: ->
    self = @
    $('#message-delete').click ->
      self.save_delete "delete", @

  wireUpNew: ->
    self = @
    self.popup = new Popup self.resource, self.popup
    self.popup.init()

  init: (options) ->
    self = @
    self.resource = options.resource
    self.resourceId = options.id
    self.popup = options.popup || {}
    self.wireUpNew()
    self.wireUpFilter()
    self.wireUpSave()
    self.wireUpDelete()
window.SharedMessage = SharedMessage

