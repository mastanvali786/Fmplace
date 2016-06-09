class Util
  @page:
    refresh: ->
      window.location.reload()

  @openBlankInNewTab: ->
    $('a.blank').click ->
      $(@).attr('target', '_blank')

  @form:
    enableReset: ->
      $('.reset').closest('form').reset()

  @enableDisabled: ->
    $('.disabled').disable()

  @globals:
    init: ->
      $.fn.disable = ->
        $(this).each ->
          $(this).prop('disabled', 'disabled')
      $.fn.enable = ->
        $(this).each ->
          $(this).removeProp('disabled')

  @money:
    format: (val) ->
      formatted = parseFloat(val).toFixed(2)
      "$#{formatted}"

  @enforceNumericInput: ->
    numericElem = $('.numeric')
    if numericElem.length
      numericElem.numeric
        allowMinus   : false
        allowThouSep : false
window.Util = Util

Util.globals.init()