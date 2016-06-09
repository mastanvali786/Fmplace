//= require modulejs
//= require controller_action
//= require chosen-jquery
//= require_tree ./coffee
//= require ckeditor/init
//= require ckeditor/config


$(function() {
  if ($("#allprop").length > 0) {
    setTimeout(updatebids, 10000);
  }
});

function updatebids () {
  console.log("coming here");
  var project_id = $("#allprop").attr("data-id");
  if($('#refresh_status').val() == 1){
    $.getScript("/projects/show.js?project_id=" + project_id)
  }
  setTimeout(updatebids, 10000);
}

// Chose for multiselect
$(document).ready(function(){
  $(".apply-chosen").chosen();
   $('[data-toggle="tooltip"]').tooltip({'placement': 'bottom'});
});

$(document).ready(function(){
  var count = $('#get_memberhsip').text()
  $("#user_skill_known_skills").chosen({
    max_selected_options: count
  });
});