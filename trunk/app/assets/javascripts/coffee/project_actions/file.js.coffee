class File
  wireUpFilesSort: ->
    $('#files-sort').change ->
      location = $(this).data('base-path')
      sort = $(this).val()
      window.location = "#{location}&sort=#{sort}"
    files_sort = $('#files-sort')
    sort = files_sort.data('sort')
    $('#files-sort').val(sort)
  wireUpUpload: ->
    $('#upload').change ->
      if ($(this).val().length)
        $('#upload-submit').fadeIn()
  init: ->
    @wireUpUpload()
    @wireUpFilesSort()

window.ProjectActions ||= {}
window.ProjectActions.File = File
