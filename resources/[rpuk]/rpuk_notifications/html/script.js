var notifs = {}

function startProgressBar(text, duration) {
	$('.progressbar-container').fadeIn(100);

	$('.bar').stop().css({ width: '0%', 'background-color': 'rgb(51, 102, 153)' }).animate({ width: '100%' }, {
		duration: duration,
		easing: 'linear',
		step: function (now, fx) {
			$('#progressBarText').html(text + ` (${Math.round(now) + '%'})`);
		}, complete: function () {
			$('.progressbar-container').fadeOut(500);
			$.post('https://rpuk_notifications/actionFinish');
		}
	});
};

function createNotification(data) {
	let $notification = $(document.createElement('div'));
	$notification.addClass('notification').addClass(data.type);
	$notification.html(data.text);
	$notification.fadeIn();

	if (data.style !== undefined) {
		Object.keys(data.style).forEach(function (css) {
			$notification.css(css, data.style[css])
		});
	}

	return $notification;
}

function updateNotification(data) {
	let $notification = $(notifs[data.id])
	$notification.addClass('notification').addClass(data.type);
	$notification.html(data.text);

	if (data.style !== undefined) {
		Object.keys(data.style).forEach(function (css) {
			$notification.css(css, data.style[css])
		});
	}
}

function showNotification(data) {
	if (data.persist != null) {
		if (data.persist.toUpperCase() == 'START') {
			if (notifs[data.id] === undefined) {
				let $notification = createNotification(data);
				$('.notification-container').append($notification);
				notifs[data.id] = {
					notif: $notification
				};
			} else {
				updateNotification(data);
			}
		} else if (data.persist.toUpperCase() == 'END') {
			if (notifs[data.id] != null) {
				let $notification = $(notifs[data.id].notif);
				$.when($notification.fadeOut()).done(function () {
					$notification.remove();
					delete notifs[data.id];
				});
			}
		}
	} else {
		if (data.id != null) {
			if (notifs[data.id] === undefined) {
				let $notification = createNotification(data);
				$('.notification-container').append($notification);
				notifs[data.id] = {
					notif: $notification,
					timer: setTimeout(function () {
						let $notification = notifs[data.id].notif;
						$.when($notification.fadeOut()).done(function () {
							$notification.remove();
							clearTimeout(notifs[data.id].timer);
							delete notifs[data.id];
						});
					}, data.length != null ? data.length : 2500)
				};
			} else {
				clearTimeout(notifs[data.id].timer);
				updateNotification(data);

				notifs[data.id].timer = setTimeout(function () {
					let $notification = notifs[data.id].notif;
					$.when($notification.fadeOut()).done(function () {
						$notification.remove();
						clearTimeout(notifs[data.id].timer);
						delete notifs[data.id];
					});
				}, data.length != null ? data.length : 2500)
			}
		} else {
			let $notification = createNotification(data);
			$('.notification-container').append($notification);

			setTimeout(function () {
				$.when($notification.fadeOut()).done(function () {
					$notification.remove()
				});
			}, data.length != null ? data.length : 2500);
		}
	}
}

window.addEventListener('message', (event) => {
	if (event.data.action == 'startProgressBar') {
		startProgressBar(event.data.label, event.data.duration);
	} else if (event.data.action == 'cancelProgressBar') {
		$('#progressBarText').html('Canceled');

		$('.bar').stop().css({ 'background-color': '#db2828' }).animate({ width: '100%' }, {
			duration: 500,
			easing: 'linear',
			complete: function () {
				setTimeout(function () {
					$('.progressbar-container').fadeOut(500);
				}, 1000);
			}
		});
	} else if (event.data.action == 'showNotification') {
		showNotification(event.data);
	}
});
