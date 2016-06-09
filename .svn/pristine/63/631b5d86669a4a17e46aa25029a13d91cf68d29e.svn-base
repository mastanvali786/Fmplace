class Accounting

  withdraw: (amount) ->
    $('#loading_spinner').show()
    self = @
    $.ajax(
      "/accounting/withdraw"
      type: 'PUT'
      dataType: "json"
      data:
        amount: amount
      success: (data) ->
        message = "Your request is being processed.<br>" +
          "You will be notified when the withdrawal of #{data.amount} has been deposited to your account.<br>" +
          "At any time you can view the status of your withdrawal requests #{data.withdrawals_url}."
        self.alert.info(message)
        $('#available').html(data.available)
        $('#available_fix').val(data.available)
        $('#amount').val('')
        $('#new-balance').html('$0.00')
        $('#withdraw').addClass('disabled')
        $('#loading_spinner').hide()
      error: (data) ->
        $('#loading_spinner').hide()
        self.alert.error("Withdrawal failed for the following reason:<br>#{data.responseJSON.message}")
    )

  withdrawAmount: ->
    parseFloat($('#amount').val())
  amount: ->
    $('#amount')
  checkWithdrawal: ->
    balance = parseFloat($('#available_fix').val().replace('$', ''))
    withdrawal = parseFloat(@amount().val())
    if withdrawal > 0 && balance >= withdrawal
      $('.amount .help').css('color', 'green')
      $('#new-balance').text(Util.money.format(balance-withdrawal))
      $('#withdraw').removeClass('disabled')
      $('#withdraw').removeAttr('disabled')
    else
      $('.amount .help').css('color', 'red')
      $('#withdraw').addClass('disabled')

  withdrawals: ->
    @alert = new Alert().init('#withdraw-messages')
    new FormValidator().init()
    Util.enforceNumericInput()
    Util.form.enableReset()
    Util.enableDisabled()
    self = @
    self.amount().blur ->
      self.checkWithdrawal()
    self.checkWithdrawal()
    $('#withdraw').click (evt) ->
      evt.stopPropagation()
      self.withdraw(self.withdrawAmount())
      false

  payments_action: ->
    $('#Items').selectbox()
    $('#Items2').selectbox()

  constructor: ->
    selected_style = "color:#30a0be;font-weight:bold;"
    main_action = (action) ->
      section = action.replace(/_/,'-')
      ->
        $("##{section}").attr("style", selected_style)
        main = this["#{action}_action"]
        if main
          main()

    for action in ["make_payment", "accounts", "witdrawals", "transactions", "payments", "deposits"]
      this[action] = main_action(action)


window.Accounting = Accounting