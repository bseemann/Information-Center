//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function(){
	$("#modal_to_move").hide();
	//$("#modal_to_create_folder").hide();
});

$("a[name='move_link']").click(function(){
	movePopUp($(this));
});

function movePopUp(thisObj){
	$("#modal_to_move").fadeIn(200);
	$("#move_from").val(thisObj.attr("id"));	
}

function closePop() {
	$("#modal_to_move").fadeOut(200);
}


function createFolderPopUp(){
	$("#modal_to_create_folder").fadeToggle(200);
}
