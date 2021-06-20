var driverData;
var currentValue = 0;
var objId = 0;

function handleClick(myRadio) {
	currentValue = myRadio.value;
	objId = myRadio.id;
}

function openTab(evt, tabId) {
	var i, tabcontent, tablinks;
	tabcontent = document.getElementsByClassName("tabcontent");
	for (i = 0; i < tabcontent.length; i++) {
		tabcontent[i].style.display = "none";
		tabcontent[i].style.zindex = 0;
	}

	tablinks = document.getElementsByClassName("tablinks");
	for (i = 0; i < tablinks.length; i++) {
		tablinks[i].className = tablinks[i].className.replace(" active", "");
	}
	document.getElementById(tabId).style.display = "inline";
	document.getElementById(tabId).style.zindex = 5;
	evt.currentTarget.className += " active";

	if (tabId == "bAccounts" || tabId == "currOrders" || tabId == "currDelivs") {
		document.getElementById("bot_content").style.display = "none";
	} else {
		document.getElementById("bot_content").style.display = "block";
	}

	if (tabId == "Vehicles") {
		document.getElementById("orderQuant").style.display = "none";
		document.getElementById("orderPrice").style.display = "none";
	} else {
		document.getElementById("orderQuant").style.display = "inline";
		document.getElementById("orderPrice").style.display = "inline";
	}

	if (tabId == "bAccounts") { // reversed because of above content
		document.getElementById("bot_content2").style.display = "none";
	} else {
		document.getElementById("bot_content2").style.display = "inline";
	}

	if (tabId == "currDelivs") { // reversed because of above content
		document.getElementById("bot_content3").style.display = "inline";
	} else {
		document.getElementById("bot_content3").style.display = "none";
	}

	if (tabId == "driver_deliv") { // reversed because of above content
		document.getElementById("bot_content4").style.display = "inline";
	} else {
		document.getElementById("bot_content4").style.display = "none";
	}
}

$(function () {
	window.addEventListener('message', function (event) {
		if (event.data.type == "enableui") {
			document.body.style.display = event.data.enable ? "block" : "none";

			if (event.data.callType === "driver") {
				document.getElementById('driver_deliv').style.display = "block"
			}

			if (event.data.callType == "keeper") {
				document.getElementById('Vehicles').style.display = "block"
				document.getElementById('driver_deliv').style.display = 'none'
			}

			$('#vehicle_input').empty();
			for (let i in event.data.vehicles) { // http://reddead.co.uk/image/veh/adder.jpg
				let inputdata = event.data.vehicles[i];
				$('#vehicle_input').append(`<label id="label_opt" style="padding:0.5%;" ><h4 style="color:white;">${inputdata[0]} <span style="color:green;">£${inputdata[2].toLocaleString()}</span></h4><input objType="vehicle" id="vehicle" type="radio" onclick="handleClick(this);" name="myRadios" value="${inputdata[1]}"><img style="width:150px;"src="http://reddead.co.uk/image/veh/${inputdata[1]}.jpg"></label>`);
			}

			$('#raw_input').empty();
			for (let i in event.data.rawmats) {
				let inputdata = event.data.rawmats[i];
				$('#raw_input').append(`<label id="label_opt" style="padding:0.5%;"><input id="raw" type="radio" onclick="handleClick(this);" name="myRadios" value="${inputdata[1]}"><img style="width:150px;"src="nui://rpuk_inventory/html/img/items/${inputdata[1]}.png"><h4 style="color:white;">${inputdata[0]}</h4></label>`);
			}

			$('#man_input').empty();
			for (let i in event.data.manugoods) {
				let inputdata = event.data.manugoods[i];
				$('#man_input').append(`<label id="label_opt" style="padding:0.5%;"><input id="manufactured" type="radio" onclick="handleClick(this);" name="myRadios" value="${inputdata[1]}"><img style="width:150px;"src="nui://rpuk_inventory/html/img/items/${inputdata[1]}.png"><h4 style="color:white;">${inputdata[0]}</h4></label>`);
			}

			$('#order_input tr:gt(0)').remove();
			for (let i in event.data.curOrders) {
				let inputdata = event.data.curOrders[i];
				$('#order_input').append(`<tr><td>${inputdata[5]}</td><td>${inputdata[0]}</td><td>${inputdata[1]}</td><td style="color:lightgreen;">£${inputdata[2].toLocaleString()}</td><td style="color:lightgreen;">£${(inputdata[1] * inputdata[2]).toLocaleString()}</td><td>${inputdata[3]}</td><td><b>${inputdata[4]}</b></td></tr>`);
			}

			$('#deliv_input tr:gt(0)').remove();
			for (let i in event.data.curDelivs) {
				let inputdata = event.data.curDelivs[i];
				$('#deliv_input').append(`<tr><td>${inputdata[5]}</td><td>${inputdata[0]}</td><td>${inputdata[1]}</td><td style="color:lightgreen;">£${inputdata[2].toLocaleString()}</td><td style="color:lightgreen;">£${(inputdata[1] * inputdata[2]).toLocaleString()}</td><td>${inputdata[3]}</td><td><b>${inputdata[4]}</b></td></tr>`);
			}

			$('#driver_input tr:gt(0)').remove();
			driverData = event.data.driverData;

			for (let i in event.data.driverData) {
				let inputdata = event.data.driverData[i];
				$('#driver_input').append(`<tr><td>${inputdata[5]}</td><td>${inputdata[0]}</td><td>${inputdata[1]}</td><td style="color:lightgreen;">£${inputdata[2].toLocaleString()}</td><td style="color:lightgreen;">£${(inputdata[1] * inputdata[2]).toLocaleString()}</td><td>${inputdata[3]}</td><td><b>${inputdata[4]}</b></td></tr>`);
			}

			$('#shop_type').empty();
			let shopType = event.data.marketType;
			$('#shop_type').append('<h5 style="position:absolute;right:1%;top:10%;color:white;">Shop Type: ' + shopType + '</h5>');

			if (event.data.enable) {
				let bankBalance = event.data.banking.toLocaleString();
				$("#bank_balance").text(bankBalance);
			}

			var rows1 = $('#order_input tr:gt(0)');
			var rows2 = $('#deliv_input tr:gt(0)');
			var rows3 = $('#driver_input tr:gt(0)');

			rows1.on('click', function (e) { var row = $(this); rows1.removeClass('highlight'); row.addClass('highlight'); });
			rows2.on('click', function (e) { var row = $(this); rows2.removeClass('highlight'); row.addClass('highlight'); });
			rows3.on('click', function (e) { var row = $(this); rows3.removeClass('highlight'); row.addClass('highlight'); });
			/*
				if ((e.ctrlKey || e.metaKey) || e.shiftKey) {
					row.addClass('highlight');
				} else {
					rows.removeClass('highlight');
					row.addClass('highlight');
				}
			*/
		}

		if (event.data.type == "updateBank") {
			let newBalance = event.data.newValue;
			$("#bank_balance").text(newBalance.toLocaleString());
		}

		if (event.data.marketType == "vehicle") {
			document.getElementById("vehTab").style.display = "inline";
			document.getElementById("rawTab").style.display = "none";
			document.getElementById("manTab").style.display = "none";

			document.getElementById("curTab").style.display = "inline";
			document.getElementById("curdTab").style.display = "inline";
			document.getElementById("accTab").style.display = "inline";
		} else if (event.data.marketType == "market") {
			document.getElementById("vehTab").style.display = "none";
			document.getElementById("rawTab").style.display = "inline";
			document.getElementById("manTab").style.display = "inline";

			document.getElementById("curTab").style.display = "inline";
			document.getElementById("curdTab").style.display = "inline";
			document.getElementById("accTab").style.display = "inline";
		}

		// hide and show depending on calltype
		if (event.data.callType == "keeper") {
			document.getElementById("keeper_content").style.display = "block";
			document.getElementById("driver_content").style.display = "none";
		} else if (event.data.callType == "driver") {
			document.getElementById("driver_content").style.display = "block";
			document.getElementById("keeper_content").style.display = "none";
		}
	});

	document.onkeyup = function (event) {
		if (event.key == 'Escape') { // Escape key
			$.post('https://rpuk_stock/escape');
		}
	};

	$("#order-form").submit(function (e) {
		e.preventDefault();

		$.post('https://rpuk_stock/order', JSON.stringify({
			quantity: $("#orderQuant").val(),
			price: $("#orderPrice").val(),
			option: currentValue,
			id: objId,
		}));
	});

	$("#bank-form-withdraw").submit(function (e) {
		e.preventDefault();

		$.post('https://rpuk_stock/bank', JSON.stringify({
			type: "withdraw",
			quantity: $("#bankWithdrawAmou").val(),
		}));
	});

	$("#bank-form-deposit").submit(function (e) {
		e.preventDefault();
		$.post('https://rpuk_stock/bank', JSON.stringify({
			type: "deposit",
			quantity: $("#bankDepositAmou").val(),
		}));
	});

	$("#cancel-order").submit(function (e) {
		e.preventDefault();
		var orderId = parseInt($('#order_input tr.highlight :first-child').html());

		if (orderId) {
			$('#order_input tr.highlight').remove();

			$.post('https://rpuk_stock/altero', JSON.stringify({
				type: "cancel_order",
				id: orderId
			}));
		}
	});

	$("#driver-accept").submit(function (e) {
		e.preventDefault();
		var orderId = parseInt($('#driver_input tr.highlight :first-child').html());

		if (orderId) {
			//$('#driver_input tr.highlight').remove();

			$.post('https://rpuk_stock/driver', JSON.stringify({
				type: driverData, // passing data back to client to perform actions on it eg type checks
				id: orderId
			}));
		}

	});

	$("#keeper-accept").submit(function (e) {
		e.preventDefault();
		var orderId = parseInt($('#deliv_input tr.highlight :first-child').html());

		if (orderId) {
			//$('#deliv_input tr.highlight').remove();

			$.post('https://rpuk_stock/altero', JSON.stringify({
				type: "accept_delivery",
				id: orderId
			}));
		}
	});

	$("#scroll-up").submit(function (e) { // when the person submits the form order-form
		e.preventDefault(); // Prevent form from submitting

		document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
	});

});