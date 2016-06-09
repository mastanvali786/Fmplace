class Project
  refresh: ->
    Util.page.refresh()

  response: (data) ->
    data.responseJSON

  update_proposal: (data) ->
    if data.data == false
      site_url = $("body").data( "siteurl" )
      alert "You have insufficient balance in "+site_url+" account. Please deposite $10 amount into your "+site_url+" account."
    else
      $('#bid .messages').empty()
      $('#bid .content').html(data.template)
      @show()

  updateProposedAmountOnMilestoneAmountChange: ->
    $('.milestone-amount').blur ->
      amount = 0
      $('.milestone-amount').each ->
        if val = $(this).val()
          amount += parseFloat(val)
      $('#bid_proposed_amount').val(amount)
      $('#bid_proposed_amount').trigger('blur')

  enforceNumericInput: ->
    if $("#bid-form").length
      $('.numeric').numeric
        allowMinus   : false
        allowThouSep : false

  wireUpAttachments: ->
    self = @
    addAttachments = $('.add-attachments')
    $('.remove-attachment').click ->
      id = $(this).data('id')
      $.ajax(
        "/bid_attachments/#{id}"
        type: 'DELETE'
        dataType: "json"
        data:
          id: id
        success: (data) ->
          $('*[data-id= '+data.id+']').remove()
          self.showUpdateProposal()
      )

    $('#add-attachments-trigger').click ->
      addAttachments.trigger('click')
    $('.add-attachments').MultiFile
      list: '#add-attachments-list'

  bidSubmitSuccess: (data) ->
    self = @
    self.update_proposal data
    self.refresh()

  bidSubmitError: (response) ->
    self = @
    error_msg = " You have crossed the monthly limit for submitting quotes:"
    $('#bid .messages').html(error_msg+"<center>"+ response.errors + "</center>")
    self.show()

  showUpdateProposal: ->
    $('#update-proposal').trigger('click')

  wireUpMilestones: ->
    self = @
    $(".remove-milestone").click ->
      milestoneId = $(@).data('id')
      $.ajax(
        "/bid_milestones/#{milestoneId}"
        type: 'DELETE'
        dataType: "json"
        data:
          id: milestoneId
        success: (data) ->
          self.showUpdateProposal()
      )
    $("#milestone-add").click ->
      milestoneId = parseInt($("#bid-milestones").attr("nextId") || 0)
      bidId = $(@).data('bidid')
      templateParams =
        id: milestoneId
        bidId:bidId
        milestone: "milestones[#{milestoneId}]"
      $("#add-bid-milestone-template").tmpl(templateParams).prependTo("#bid-milestones")
      $("#bid-milestones").attr("nextId", milestoneId + 1)
      $(".milestone-remove").click ->
        parent = $(this).data('parent')
        $(parent).remove()
      $("#milestone-cal-#{milestoneId}").datepick({showTrigger:"#milestone-cal-icon-#{milestoneId}"})
      self.enforceNumericInput()
      self.updateProposedAmountOnMilestoneAmountChange()

  show: ->
    self = @
    self.enforceNumericInput()
    self.wireUpAttachments()
    self.wireUpMilestones()

    $("#bid-form").on "submit", (event) ->
      event.preventDefault()
      $(@).ajaxSubmit
        success: (data) ->
          $('#loading_spinner').hide()
          self.bidSubmitSuccess data
        error: (data) ->
          $('#loading_spinner').hide()
          self.bidSubmitError data.responseJSON


    $('#update-proposal').on "ajax:success", (success, data) ->
      self.update_proposal data

    $('#withdraw-proposal').on "ajax:success", (success, data) ->
      self.refresh()

    $('#bid_proposed_amount').blur ->
      amount = ""
      if val = $(this).val()
        amount = parseFloat($(this).val())
        per = service_fee
        amount = (amount - (per*amount/100)).toFixed(2)
      $("#bid_earned_amount").val(amount)

  index: ->
   $('#search_form').submit (event)->
    event.preventDefault()
    q = encodeURIComponent($(this).find('[name=q]').val())
    window.location = "#{$(this).attr('action')}?q=#{q}"

window.Project = Project
