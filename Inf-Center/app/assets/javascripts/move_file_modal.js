//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function(){
	$("#modal_to_move").hide();
});


function movePopUp(){
	$("#modal_to_move").fadeToggle(200);
}