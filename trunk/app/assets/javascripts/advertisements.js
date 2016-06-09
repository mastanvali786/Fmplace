$(document).ready(function() {
  if($('.specific_date').is(":checked")){
     $('#ad_stop_date_div').show();
      $('#advertisement_show_continuously').val('false');
  }
	$('#ad_spec_date_radio input[type=radio]').click(function() {
	  if($(this).attr("value")=="false"){ 
      $('#ad_stop_date_div').show();
      $("#advertisement_stop_date").val($.datepicker.formatDate("dd/mm/yy", new Date()));
      $('#advertisement_show_continuously').val('false');
    }else{
    	$('#ad_stop_date_div').hide();
      $('#advertisement_stop_date').val("")
      $('#advertisement_show_continuously').val('true');
    }
});

	$("#post_update_banner_ad").click(function(event){
    event.preventDefault();
    var day_week = $("#banner_show_day_check input:checkbox:checked").map(function(){
      return $(this).val();
    }).get();
    var page_section = $("#ad_section_ids_banner input:checkbox:checked").map(function(){
      return $(this).val();
    }).get();
    $('#advertisement_days_week').val(day_week);
    $('#advertisement_ad_sections_ids').val(page_section);
    $('.advertisement_form').submit();
});

  // Fund From Buyer
  $('.call_controller').bind('ajax:beforeSend', function() {
    //$('#loading_spinner').show();
  });

  $('.call_controller').on('ajax:success',
    function(e, data, status, xhr)
    {
      $('#loading_spinner').hide();
      if(data.status == true){
        var banner_url = data.url;
          if (banner_url && !banner_url.match(/^http([s]?):\/\/.*/)) {
            banner_url = 'http://' + banner_url;
          }
        var win = window.open(banner_url, '_blank');
        if(win){
            //Browser has allowed it to be opened
            win.focus();
        }else{
            //Broswer has blocked it
            alert('Please allow popups for this site');
        }
  }
  });

  $('.call_controller').on('ajax:error',
    function(e, data, status, xhr)
    {
      $('#loading_spinner').hide();
  });
$(".advertisement_form").submit(function(){
if($('#banner_show_day_check input[type=checkbox]:checked').length == 0)
{
var result = confirm("on all days this will be displayed");
if(result == false)
{
  return false;
}}
});


$(document).ready(function(){

  jQuery('.ad_date').datetimepicker({
    format:'d/m/Y',
    minDate: 0,
    timepicker: false
  });
});
});