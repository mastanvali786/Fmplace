// Project Start date
$(document).ready(function(){
  var logic = function( currentDateTime ){
  // 'this' is jquery object datetimepicker
  var d = new Date();
  var h = d.getHours();
  var n = d.getDate();
  current_date = currentDateTime.getDate();
  if( current_date == n ){
    this.setOptions({
      minTime:'h:00'
    });
  }
  else
    this.setOptions({
      minTime:'0:00'
    });
};
jQuery('.project_start_date').datetimepicker({
  formatDate:'Y/m/d',
  onChangeDateTime:logic,
  onShow:logic,
  minDate: 0,
  step: 15
});

jQuery('.experience_start_date').datetimepicker({
  timepicker:false,
  maxDate: 0,
  format:'d.m.Y'
});

jQuery('.experience_end_date').datetimepicker({
  timepicker:false,
  format:'d.m.Y',
  maxDate: 0,
});

jQuery('.education_start_date').datetimepicker({
 timepicker:false,
 maxDate: 0,
 format:'d.m.Y'
});

jQuery('.education_end_date').datetimepicker({
 timepicker:false,
 maxDate: 0,
 format:'d.m.Y'
});
});


function convert_price (price) {
  var new_price = parseFloat(price).toFixed(2);
  new_price="$"+new_price
  return new_price;
}

function convert_price_in_comma(price1)
{
  var new_price=price1.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');
   new_price="$"+new_price
  return new_price;
}
// Project End date
$(document).ready(function(){
  var logic = function( currentDateTime ){
  // 'this' is jquery object datetimepicker
  var d = new Date();
  var h = d.getHours();
  var n = d.getDate();
  current_date = currentDateTime.getDate();
  if( current_date == n ){
    this.setOptions({
      minTime:'h:00'
    });
  }
  else
    this.setOptions({
      minTime:'0:00'
    });
};
jQuery('.project_end_date').datetimepicker({
  formatDate:'Y/m/d',
  onChangeDateTime:logic,
  onShow:logic,
  minDate: 0,
  step: 15
});
});

$(document).ready(function() {
  var url= window.location.href;
  if(/=/i.test(url)){
    var result = url.split('=').pop();
    var status = getUrlVars()["find_status"];
    var find_posted = getUrlVars()["find_posted"];
    if (typeof(status) == 'undefined')
    {
     $("#search_status_project").val('all');  
   }
   else
   {
    $("#search_status_project").val(result);
  }
}
});

function getUrlVars(){
  var vars = [], hash;
  var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
  for(var i = 0; i < hashes.length; i++)
  {
    hash = hashes[i].split('=');
    vars.push(hash[0]);
    vars[hash[0]] = hash[1];
  }
  return vars;
}

// function show_read_more(id){
//   if ($('.full_state2_'+id).css('display') == 'inline'){
//     $('.full_state2_'+id).css('display','none'); 
//     $(".full_state2_"+id).hide("slow");
//     $('.flip2_'+id).html('Read more');
//   }
//   else{
//     $(".full_state2_"+id).show("slow");
//     $('.full_state2_'+id).css('display','inline');
//     $('.flip2_'+id).html('Read less');
//   }
// }

function hide_modal(class_name){
  $('.'+class_name).modal('hide');
}


function show_read_more(id){
  if ($('.full_state2_'+id).css('display') == 'inline'){
    $('.full_state2_'+id).css('display','none'); 
    $(".full_state2_"+id).hide("slow");
    $('.flip2_'+id).html('<i class="fa fa-sort-desc fa-2x "></i> More');
  }
  else{
    $(".full_state2_"+id).show("slow");
    $('.full_state2_'+id).css('display','inline');
    $('.flip2_'+id).html('<i class="fa fa-sort-asc fa-2x "></i> <span style="position: relative; top: -12px;">Less</span>');
  }
}

function award_confirmation_bid(project_id_status, bid_id_status) {
  var mydata = {"bid_id": bid_id_status, "id": project_id_status};
  $.ajax({
    type:'POST',
    url:'/projects/change_status',
    data: mydata,
    success:function(data){
      if(data && data.status == 'success'){
        var name = data.user_name;
        $('#status_message').text('You have selected '+name+' for your project. Your seller has been notified and a workroom has been created. Be sure to upload any necessary files, send messages to your seller, create milestones and fund the project escrow account for your seller to commence working.');
      }else{
        $('#status_message').text('Please try after some time.');
      }
      $('#award_message_modal').modal('show');
    }
  });
}

$(document).ready(function(){
  $('#award_message_modal').on('hidden.bs.modal', function () {
    window.location.reload();
  });
});

$(document).ready(function(){
  $('#submit_new_project').click(function(e) {
    if( false == $('#new_project').parsley().validate()){
      return false;
    }
    else{
      var bid_end = $('#project_end_date').val();
      var now = new Date(bid_end);
      $('#project_end_date').val(now);
    }
    var date = moment($('#project_end_date').val());
    var now = moment();
    if (date <= now) {
     alert("Project end time must be greater than current time.");
     return false;
   }
 });
});

$(document).ready(function(){
  $('#getstartedseller').click(function(e) {
    if( false == $('#signup_seller_id').parsley().validate() || $('.hidden_number').val() == '0'){
      return false;
    }else{
      set_long_lat();
      return false;
    }
  });
});

function set_long_lat(){
  var address='';
  address += $(".map_address").val()+',';
  address+= $('.map_country option:selected').text()+',';
  address+= $('.map_state option:selected').text()+',';
  address+=$(".map_city").val()+',';
  address+=$(".map_zipcode").val();
  var geocoder= new google.maps.Geocoder();
  geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      var lat=results[0].geometry.location.lat();
      var lng=results[0].geometry.location.lng();
      $('.map_lat').val(lat);
      $('.map_lng').val(lng);
      $('#signup_seller_id').submit();
    } else {
      $('.map_lat').val(0);
      $('.map_lng').val(0);
      $('#signup_seller_id').submit();
    }
  });
}


$(document).ready(function(){
  $('#post_project').click(function(e) {
    if( false == $('#new_user').parsley().validate() && $('.hidden_number').val() == '0'){
      return false;
    }
    else{
      var bid_end = $('#user_project_end_date').val();
      var now = new Date(bid_end);
      $('#user_project_end_date').val(now);
    }
    var date = moment($('#user_project_end_date').val());
    var now = moment();
    if (date <= now) {
     alert("Project end time must be greater than current time.");
     return false;
   }
 });
});

$(document).ready(function(){
  $('.action_menu').click(function(e) {
    $('.action_menu').removeClass('active');
    $(this).addClass('active');
  });

  $(function() {
    $(".video-link").jqueryVideoLightning({
      autoplay: 1,
      backdrop_color: "#ddd",
      backdrop_opacity: 0.6,
      glow: 20,
      glow_color: "#000"
    });
  });
});

function edit_note_fun(id)
{
  $('#refresh_status').val('0');
  $("#msg_send"+id).hide("slow");
  $("#edit_note_"+id).show("slow");
}

function edit_message_fun(id)
{
  $('#refresh_status').val('0');
  $("#edit_note_"+id).hide("slow");
  $("#msg_send"+id).show("slow");
}


function hide_show(id){
  $('#refresh_status').val('1');
  $('#'+id).hide();
}

// Popup for Youtube Video.
$(document).ready(function(){
  $("a.youtube").YouTubePopup({ title: "Video" });
});

$(document).ready(function() {
  var terms_buyer = $("#terms_buyer");
  var terms_seller = $('#terms_seller');
  var terms_post = $('#terms_post');
  terms_buyer.click(function() {
    if ($(this).is(":checked")) {
      $("#post_project").removeAttr("disabled");
    } else {
      $("#post_project").attr("disabled", "disabled");
    }
  });
  terms_seller.click(function() {
    if ($(this).is(":checked")) {
      $("#getstartedseller").removeAttr("disabled");
    } else {
      $("#getstartedseller").attr("disabled", "disabled");
    }
  });
  terms_post.click(function() {
    if ($(this).is(":checked")) {
      $("#submit_new_project").removeAttr("disabled");
      $('#hire_freelancer').removeAttr("disabled");
    } else {
      $("#submit_new_project").attr("disabled", "disabled");
      $('#hire_freelancer').attr("disabled", "disabled");
    }
  });
}); 


$(document).ready(function () {
  //called when key is down
  $(".number-only").bind("keydown", function (event) {
    if ( event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
             // Allow: Ctrl+A
             (event.keyCode == 65 && event.ctrlKey === true) || 

        // Allow: home, end, left, right
        (event.keyCode >= 35 && event.keyCode <= 39)) {
              // let it happen, don't do anything
            return;
          } else {
            // Ensure that it is a number and stop the keypress
            if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 )) {
              event.preventDefault();
            }
          }
        });
});

$(document).ready(function(){
  $('.zip_code_populate').bind('change focusout', function () {
   var $this = $(this);
   var zip = $this.val()
   if ($this.val().length != 5) {
    $(".zip_code_populate").val('');
    $(".zip_code_populate").attr("placeholder", "Enter valid zip code");
  }else
  {
    $.ajax({
      url: "/projects/listzip",
      type: "post",
      dataType: "json",
      data: {zip:zip},
      success: function(data) {
        if(data.present=='true')
        {
          $('.zip_code_populate_state').val(data.state);
          $('.select_state').html('<option val="'+data.state+'">'+data.state+'</option>'); 
          $('.zip_code_populate_city').val(data.city);
        }
        else
        {
          $(".zip_code_populate").val('');
          $('.zip_code_populate_city').val('');
          $('.select_state').val('');
          $(".zip_code_populate").attr("placeholder", "Enter valid US zip code");
        }
      }
    });

  }
})
});

function getParameterByName(name) {
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
  var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
  results = regex.exec(location.search);
  return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function hide_show_by_id(hide_id, show_id){
  $('#'+hide_id).hide();
  $('#'+show_id).show();
}

function exapnd_collapse(content_id,header_id){
 $('#'+content_id).toggle();
 if ($('#'+content_id).css('display') == 'none'){
  $('#'+header_id).html('<img src="/assets/expand_collapsed.gif" alt />');
}else{
  $('#'+header_id).html('<img src="/assets/expand.gif" alt />')
}
}

// Report Violation
function report_violation(bid_id) {
  $('#refresh_status').val('0');
  $('#bid_id_report').val(bid_id);
  $('#myModal').modal();
}

$(document).ready(function(){
  $("#loagin_as_role").change(function(){
    var value= $('#loagin_as_role').val();
    $.ajax({
      url: '/homes/demo_logins',
      type: "POST",
      data: {value: value}
    });
  });
});


$(document).on("click", ".braintree_open_pay_modal", function () {
 var invoice_id = $(this).data('id');
 var amount = $(this).data('amount');
 $("#invoice_id").val( invoice_id );
 $('.fund_pay_braintree').val("Pay "+parseFloat(amount)+"$");
});

$(document).ready(function(){
  $('.clock_comman').each(function(){
    var end_date = $(this).data('until');
    $(this).countdown(end_date).on('update.countdown', function(event) {
     var $this = $(this).html(event.strftime(''
      + '%D D: '
      + '%H H: '
      + '%M M: '
      + '%S S'));
   });
  });

});

