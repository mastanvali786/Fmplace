class Account

  constructor: ->
    selected_style = "color:#30a0be;font-weight:bold;"
    main_action = (action) ->
      section = action.replace(/_/,'-')
      ->
        $("##{section}").attr("style", selected_style)
        main = this["#{action}_action"]
        if main
          main()

    for action in ["preferences", "info", "facebook", "profile"]
      this[action] = main_action(action)


window.Account = Account