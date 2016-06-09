$(document).ready(function(){
  var maxLength = 2000;
  $('.feed_comment').keyup(function() {
    var length = $(this).val()
    var newLines = length.match(/(\r\n|\n|\r)/g);
        var addition = 0;
        if (newLines != null) {
            addition = newLines.length;
        }
    var length = maxLength-length.length -addition;
     if(length == 0 || length < 0){
      length = 0;
    }
    $('.char').text(length);
  });

	$('select#files-sort').change( function() {
		var pid= $('#project_id_on_select').val();
		if(pid){
			window.location = '/projects/action/file?id='+pid+'&sort='+$(this).val();
		}
	});

	$(document).ready(function() {
		var array_list = ['file_name','uploaded_by','file_size'];
		var url= window.location.href;
		if(/=/i.test(url)){
			var result = url.split('=').pop();
			var status = getUrlVars()["sort"];
			if(status == 'file_name' || 'uploaded_by' || 'file_size')
			if ($.inArray(status, array_list) == -1)
			{
				$("#files-sort").val('created_at');  
			}
			else
			{
				$("#files-sort").val(result);
			}
		}
	});
});

$(document).ready(function(){

  // Fund From Buyer
  $('.fund-link').bind('ajax:beforeSend', function() {
    $('#loading_spinner').show();
  });

  $('.fund-link').on('ajax:success',
    function(e, data, status, xhr)
    {
      $('#loading_spinner').hide();
      if(data.pay_method == 'PAYPAL'){
        var invoice, milestoneId = data.milestone;
        $("#milestone_fund_"+milestoneId).html("Funding Requested");
        invoice = "<a href='" + data.invoiceUrl + "' class='blank' >invoice</a>";
        this.alert = new Alert().init('#payment-messages');
        this.alert.info(("An " + invoice + " has been generated and emailed to you.<br/>")
          + ("You may follow this link <a href='" + data.payerViewUrl
          + "' class='blank'>here</a> to make the payment now.<br/>")
          + ("Or at a later time by proceeding to the " + invoice
          + " directly."));
      }else{
        this.alert = new Alert().init('#payment-messages');
        this.alert.info(("Invoice Is generated for you. Please fund milestone using pay button."));
        Util.page.refresh();
      }
    }
  );

  $('.fund-link').on('ajax:error',
    function(e, data, status, xhr)
    {
      $('#loading_spinner').hide();
      this.alert = new Alert().init('#payment-messages');
      if (data.responseJSON.message){
        this.alert.info(data.responseJSON.message)
      }
      else{
        this.alert.info("An error occured has been occured.<br/>Please try after some time.");
      }
    }
  );

    // Fund From Buyer
  $('.deposit-link').bind('ajax:beforeSend', function() {
    $('#loading_spinner').show();
  });

  $('.deposit-link').on('ajax:success',
    function(e, data, status, xhr)
    { 
      $('#loading_spinner').hide();
      if(data.pay_method == 'PAYPAL'){
        var invoice;//, milestoneId = data.milestone;
        //$("#milestone_fund_"+milestoneId).html("Funding Requested");
        invoice = "<a href='" + data.invoiceUrl + "' class='blank' >invoice</a>";
        this.alert = new Alert().init('#deposit-messages');
        this.alert.info(("An " + invoice + " has been generated and emailed to you.<br/>")
          + ("You may follow this link <a href='" + data.payerViewUrl
          + "' class='blank'>here</a> to make the payment now.<br/>")
          + ("Or at a later time by proceeding to the " + invoice
          + " directly."));
      }
      else {
        window.location.href = data.payment_settings
    }
    }
  );

  $('.deposit-link').on('ajax:error',
    function(e, data, status, xhr)
    {
      $('#loading_spinner').hide();
      this.alert = new Alert().init('#deposit-messages');
      if (data.responseJSON.message){
        this.alert.info(data.responseJSON.message)
      }
      else{
        this.alert.info("An error occured has been occured.<br/>Please try after some time.");
      }
    }
  );

  // Request for fund from seller

  $('.request-fund-link').bind('ajax:beforeSend', function() {
    $('#loading_spinner').show();
  });

  $('.request-fund-link').on("ajax:success",
    function(e, data, status, xhr)
    {
      var status = "Funding Requested",
      info_msg = "An invoice has been generated and emailed to your Client.",
      div_milestoneId= "milestone_fund_"+data.milestone;
      update_payment_status(div_milestoneId, status, info_msg);
    }
  );

  $('.release-fund').bind('ajax:beforeSend', function() {
    $('#loading_spinner').show();
  });

   $('.release-fund').on("ajax:success",
    function(e, data, status, xhr)
    { 
      var status = "Release Funds Requested",
      info_msg = "Request for release fund sent to admin Successfully.",
      div_milestoneId= "milestone_release_"+data.milestone;
      update_payment_status(div_milestoneId, status, info_msg);
    }
  );
  $('#mark_as_complete').bind('ajax:beforeSend', function() {
    $('#loading_spinner').show();
  });

  $('#mark_as_complete').on("ajax:success",
    function(e, data, status, xhr)
    {
      $('#loading_spinner').hide();
      if(data == 'true'){
        var site_url = $( "body" ).data( "siteurl" );
      $('#status_message_complete').text('Thank you for using '+site_url+' for your project. This project is now marked as Complete.')        
      }else{
      $('#status_message_complete').text('Please fund or delete pending milestones or atleast you have to pay one milestone to your seller to do Mark as Complete.')        
      }
      $('#complete_project_modal').modal('show');
    }
  );

  $('#mark_as_complete').on("ajax:error",
    function(e, data, status, xhr)
    {
      $('#loading_spinner').hide();
      $('#status_message_complete').text('There is some problem to mark as complete this project. Please try after some time.')
      $('#complete_project_modal').modal('show');
    }
  );

  $(document).ready(function(){
    $('#complete_project_modal').on('hidden.bs.modal', function () {
      window.location.reload();
    });
  });

  function update_payment_status(div_milestoneId, status, info_msg){
    $('#loading_spinner').hide();
    if(div_milestoneId){
      $('#'+div_milestoneId).html(status);
    }
    this.alert = new Alert().init('#payment-messages');
    this.alert.info(info_msg);
  }

});
