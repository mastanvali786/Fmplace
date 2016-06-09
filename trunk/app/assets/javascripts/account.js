$(document).ready(function() {
 $(".user_phone_number_class").intlTelInput({
    //autoFormat: false,
    //autoHideDialCode: false,
    //defaultCountry: "jp",
    //nationalMode: true,
    //numberType: "MOBILE",
    //onlyCountries: ['us', 'gb', 'ch', 'ca', 'do'],
    //preferredCountries: ['cn', 'jp'],
    //responsiveDropdown: true,
    utilsScript: "/assets/utils.js"
  });
 $("#phone").intlTelInput({
    //autoFormat: false,
    //autoHideDialCode: false,
    //defaultCountry: "jp",
    //nationalMode: true,
    //numberType: "MOBILE",
    //onlyCountries: ['us', 'gb', 'ch', 'ca', 'do'],
    //preferredCountries: ['cn', 'jp'],
    //responsiveDropdown: true,
    utilsScript: "/assets/utils.js"
  });

 var telInput = $(".user_phone_number_class"),
 errorMsg = $(".error_msg_class"),
 validMsg = $(".valid_msg_class"),
 hidden_num = $('.hidden_number');

// initialise plugin
telInput.intlTelInput({
  utilsScript: "/assets/utils.js"
});

// on blur: validate
telInput.blur(function() {
  if ($.trim(telInput.val())) {
    if (telInput.intlTelInput("isValidNumber")) {
      validMsg.removeClass("hide");
      errorMsg.addClass("hide");
      hidden_num.val('1');
    } else {
      telInput.addClass("error");
      errorMsg.removeClass("hide");
      validMsg.addClass("hide");
      hidden_num.val('0');
    }
  }
});

});

$(document).ready(function() {
  $('#filter_by_search').bind('change',function () {
  	if(!getParameterByName("past_date") == ''){
  		var past_date = getParameterByName("past_date");
  		window.location = '/accounting/payment_list?filter='+$(this).val()+'&past_date='+past_date;
  	}else{
  		window.location = '/accounting/payment_list?filter='+$(this).val();
  	}
  });
  var filter = getParameterByName("filter");
  if (filter == ''){
    $("#filter_by_search").val('all');   
  }else{
    $("#filter_by_search").val(filter);	
  }

  $('#past_date_search').bind('change',function () {
   if(!getParameterByName("filter") == ''){
    var filter = getParameterByName("filter");
    window.location = '/accounting/payment_list?past_date='+$(this).val()+'&filter='+filter;
  }else{
   window.location = '/accounting/payment_list?past_date='+$(this).val();
 }
});
  var past_date = getParameterByName("past_date");
  if (past_date == ''){
    $("#past_date_search").val('');   
  }else{
    $("#past_date_search").val(past_date);	
  }

});