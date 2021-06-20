window.addEventListener("message", function(event) {
	if (event.data.action == "show") {
		let img = "img/" + event.data.item + ".jpg";
		$("#main").css("background-image", "url("+img+")");
		$("html,body").show("slow");
	} else {
		$("html,body").hide("slow");
		$.post('https://rpuk_manufacturing/onCloseMenu');
	}
})

document.onkeydown = function (event) {
	if (event.key == 'Escape') {
		$("html,body").hide();
		$.post('https://rpuk_manufacturing/onCloseMenu');
	}
};

$('html,body').bind("mousewheel", function() {
	return false;
});