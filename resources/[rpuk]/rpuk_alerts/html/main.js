$('document').ready(function() {
	alerts = [];
	stuckId = '';

	window.addEventListener('message', function (event) {
		if (event.data.action == "display") {
			ShowNotif(event.data);
		} else if (event.data.action == "historyOpen") {
			$( "div" ).empty();
			ShowHistory();
		} else if (event.data.action == "historyClose") {
			$( "div" ).empty();
			if (stuckId !== '') {
				StickNotif(stuckId, true);
			}
		}
	});

	function ShowHistory() {
		for (i = alerts.length - 1; i > alerts.length - 20; i--) {
			if(alerts[i] !== undefined) {
				pData = alerts[i];
				pData.length = 100000000000;
				ShowNotif(pData)
			}
		}
	}

	function ShowNotif(data) {
			var $notification = CreateNotification(data);
			$('.notif-container').append($notification);
			setTimeout(function() {
				$.when($notification.fadeOut()).done(function() {
					$notification.remove()
				});
			}, data.length != null ? data.length : 2500);
	}

	function StickNotif(id, skip) {
		if (stuckId !== id || skip) {
			if (stuckId !== '') {
				alerts[stuckId].info["sticky"] = '';  
			}
			stuckId = id
			alerts[id].info["sticky"] = ' <i class="fa fa-thumb-tack"></i>';
			var $notification = CreateNotification(alerts[id]);
			$('.notif-container').append($notification);
		} else {
			stuckId = '';
			$( "div" ).empty();
			alerts[id].info["sticky"] = '';
		}
	}

	function DeleteNotif(alert) {
		const index = alerts.indexOf(alert)
		alerts.splice(index, 1)
	}


	function CreateNotification(data) {
		var regDiv = '';
		if (data.info["veh-reg"] !== undefined){
			data.info["veh-reg"] = decodeURI(escape(data.info["veh-reg"]))
			data.info["veh-model"] = decodeURI(escape(data.info["veh-model"]))
			regDiv = '<div id="vehicle-reg"><i class="fa fa-id-card-o"></i> ' + data.info["veh-reg"] + '</div>\
			<div id="vehicle-reg"><i class="fa fa-car"></i> ' + data.info["veh-model"] + '</div>'
		}
		if (data.info["officer-name"] !== undefined){
			data.info["officer-name"] = decodeURI(escape(data.info["officer-name"]))
			data.info["radio-freq"] = decodeURI(escape(data.info["radio-freq"]))
			regDiv = '<div id="vehicle-reg"><i class="fa fa-user"></i> Officer ' + data.info["officer-name"] + '</div>\
			<div id="vehicle-reg"><i class="fa fa-volume-control-phone"></i> Radio Freq ' + data.info["radio-freq"] + '</div>'
		}

		if (data.info["extra-notes"] !== undefined){
			data.info["extra-notes"] = decodeURI(escape(data.info["extra-notes"]))
			regDiv = '<div id="vehicle-reg"><i class="fa fa-volume-control-phone"></i> Notes: ' + data.info["extra-notes"] + '</div>'
		}

		if (data.info["dispatch"] !== undefined){
			regDiv = '<div id="vehicle-reg"><i class="fa fa-volume-control-phone"></i> Notes: ' + data.info["dispatch"] + '</div>'
		}

		if (data.info["gender"] !== undefined){
			data.info["gender"] = decodeURI(escape(data.info["gender"]))
			regDiv = '<div id="vehicle-reg"><i class="fas fa-mars"></i>' + data.info["gender"] + '</div>'
		}
		
		if (data.stored == undefined) { //Storing the notifications and making sure not to store again if already stored
			data.stored = true;
			data.info["sticky"] = '';
			data.info["time"] = calcTime('+1');
			data.info["id"] = alerts.length;
			alerts.push(data);
		}
		var $notification = $(document.createElement('div'));
		$notification.addClass('notification').addClass(data.style);
		$notification.html('\
		<div class="content">\
		<div id="code">' + data.info["code"] + '</div>\
		<div id="alert-name">' + data.info["name"] + ' ' + data.info["sticky"] + '</div>\
		<div id="marker"><i class="fas ' + data.info["icon"] + '" aria-hidden="true"></i></div>\
		<div id="alert-time"><i class="fa fa-clock-o"></i> ' + data.info["time"] + '</div>\
		<div id="alert-info"><i class="fa fa-location-arrow"></i> ' + data.info["loc"] + '</div>'
		+ regDiv + 
		' </div>');
		$notification.mouseup(function(event) {
			switch (event.which) {
				case 1:
					$( "div" ).empty();
					$.post('https://rpuk_alerts/gps', JSON.stringify({x : data.info["coords"].x, y : data.info["coords"].y}));
					break;
				case 2:
					$( "div" ).empty();
					DeleteNotif(data)
					ShowHistory()
					break;
				case 3:
					$( "div" ).empty();
					StickNotif(data.info["id"], false)
					$.post('https://rpuk_alerts/gps', JSON.stringify({x : data.info["coords"].x, y : data.info["coords"].y}));
					break;
				
			}
		});
		$notification.fadeIn();
		if (data.style !== undefined) {
			Object.keys(data.style).forEach(function(css) {
				$notification.css(css, data.style[css])
			});
		}
		return $notification;
	}

	function calcTime(offset) {
		d = new Date();
		utc = d.getTime() + (d.getTimezoneOffset() * 60000);
		nd = new Date(utc + (3600000*offset));
		return nd.toLocaleTimeString([], {hour12: false, hour: '2-digit', minute:'2-digit'});
	}

	document.onkeyup = function (event) {
		if (event.key == 'Escape') {
			$( "div" ).empty();
			$.post('https://rpuk_alerts/exit');
			return
		}
	};
});