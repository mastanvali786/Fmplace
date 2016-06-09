class MilestoneInvoice
  wireUpAlert: ->
    @alert = new Alert().init('#milestone-messages')

  show: ->
    Util.openBlankInNewTab()

  index: ->
    @wireUpAlert()
    Util.openBlankInNewTab()

window.MilestoneInvoice = MilestoneInvoice