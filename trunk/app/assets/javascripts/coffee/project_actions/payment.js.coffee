class Payment

  updateMilestoneRequestFundStatus: (milestoneId) ->
    $("#milestone-#{milestoneId} .request-fund").html("<b><span class='status'>Funding Requested</span></b>")

  updateMilestoneReleaseFundStatus: (milestoneId) ->
    $("#milestone-#{milestoneId} .release-fund").html("<b><span class='status'>Release Funds Requested</span></b>")

  updateMilestoneFundStatus: (milestoneId) ->
    $("#milestone-#{milestoneId} .fund").html("<b><span class='status'>Funding Requested</span></b>").css("padding-left", "0")

  wireUpFund: ->
    self = @
    $('.fund-link').on "ajax:success", (success, data) ->
      self.updateMilestoneFundStatus(data.milestone)
      invoice = "<a href='#{data.invoiceUrl}' class='blank' >invoice</a>"
      self.alert.info("An #{invoice} has been generated and emailed to you.<br/>" +
        "You may follow this link <a href='#{data.payerViewUrl}' class='blank'>here</a> to make the payment now.<br/>"+
        "Or at a later time by proceeding to the #{invoice} directly.<br/>" +
        "Be sure to mark the #{invoice} as funded after you make the payment."
      )
      Util.openBlankInNewTab()
      window.open data.payerViewUrl

  wireUpRequestFund: ->
    self = @
    $('.request-fund-link').on "ajax:success", (success, data) ->
      self.updateMilestoneRequestFundStatus(data.milestone)

  wireUpReleaseFund: ->
    self = @
    $('.release-fund-link').on "ajax:success", (success, data) ->
      self.updateMilestoneReleaseFundStatus(data.milestone)

  init: ->
    @wireUpRequestFund()
    @wireUpReleaseFund()
    @wireUpFund()
    @alert = new Alert().init('#payment-messages')

window.ProjectActions ||= {}
window.ProjectActions.Payment = Payment