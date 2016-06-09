$(document).ready(function(){
	$(".download_links span:nth-child(1)").hide();
	$(".download_links a:nth-child(2)").text('Download Report');
	$(".download_links a:nth-child(3)").hide();
	$(".download_links a:nth-child(4)").hide();
});

function project_details(id){
	$( "#dialog-message" ).load('/admin/projects/view_project/'+ id).css({overflow:"auto" }).dialog({
		modal: true,
		width: 700,
		height: 500
	});
}

function payment_details(id){
	$( "#dialog-message" ).load('/admin/projects/view_project/'+ id).dialog({
		modal: true,
		width: 1000,
		height: 1500
	});
}
function payfast_withdrawals(id){
	$( "#dialog-payfast" ).load('/admin/payments/payfast_withdrawals/'+ id).dialog({
		modal: true,
		width: 500,
		height: 230
	});
}

function authorize_credit_withdrawals(id){
	$( "#dialog-payfast" ).load('/admin/payments/authorize_credit_withdrawals/'+ id).dialog({
		modal: true,
		width: 500,
		height: 230
	});
}