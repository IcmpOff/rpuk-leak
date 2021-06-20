$(function () {
	window.addEventListener('message', function (event) {
		if (event.data.type == "enableui") {
			document.body.style.display = event.data.enable ? "block" : "none";

			$('#rpuk_frame').empty();
			$('#rpuk_frame').append('<iframe src="' + event.data.iframe + '" width="1100" height="810"></iframe>');
		}
		else if (event.data.type == "guide") {
			document.body.style.display = event.data.enable ? "block" : "none";

			$('#rpuk_frame').empty();
			$('#rpuk_frame').append('<iframe src="https://docs.google.com/presentation/d/e/2PACX-1vRzCZLvCyLwKxfE7cCRzLtwUdXLFfJNey-JYxcwXXz486NJMhSffqCjC1vYJhyT6PYItWa3fmg7C5aP/embed?start=true&loop=true&delayms=300000" frameborder="0" width="1100" height="810" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>');

		}
		else if (event.data.type == "backHome") {
			document.body.style.display = "block";
		} else if (event.data.type == "imgur") {
			var image = event.data.image.slice(23);
			var formData = new FormData();
			formData.append("image", image);

			var settings = {
				"async": true,
				"crossDomain": true,
				"url": "https://api.imgur.com/3/image",
				"method": "POST",
				"datatype": "json",
				"headers": { "Authorization": "Client-ID 1ace87c7f90e34d" },
				"processData": false,
				"contentType": false,
				"data": formData,
				success: function (res) {
					$.post('https://rpuk_core/imgurUploaded', JSON.stringify({ url: res.data.link }));
				}
			}

			$.ajax(settings).done(function (response) { });
		} else if (event.data.transactionType && event.data.transactionType == "playSound") {
			play(event.data.transactionData);
		} else if (event.data.transactionType && event.data.transactionType == "stopSound") {
			stop();
		} else if (event.data.transactionType == "volume") {
			setVolume(event.data.transactionData);
		}
	});

	document.onkeyup = function (event) {
		if (event.key == 'Escape') {
			$.post('https://rpuk_core/NUIFocusOff');
		}
	};

	dragElement(document.getElementById("tablet"));

	function dragElement(elmnt) {
		var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
		if (document.getElementById(elmnt.id + "header")) {
			document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
		} else {
			elmnt.onmousedown = dragMouseDown;
		}

		function dragMouseDown(e) {
			e = e || window.event;
			e.preventDefault();
			pos3 = e.clientX;
			pos4 = e.clientY;
			document.onmouseup = closeDragElement;
			document.onmousemove = elementDrag;
		}

		function elementDrag(e) {
			e = e || window.event;
			e.preventDefault();
			pos1 = pos3 - e.clientX;
			pos2 = pos4 - e.clientY;
			pos3 = e.clientX;
			pos4 = e.clientY;
			elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
			elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
		}

		function closeDragElement() {
			document.onmouseup = null;
			document.onmousemove = null;
		}

		function closeFrame() {
			$.post('https://rpuk_core/NUIFocusOff', JSON.stringify({}));
		};
	}

	//YouTube IFrame API player.
	var player;

	//Create DOM elements for the player.
	var tag = document.createElement('script');
	tag.src = "https://www.youtube.com/iframe_api";

	var ytScript = document.getElementsByTagName('script')[0];
	ytScript.parentNode.insertBefore(tag, ytScript);

	function onYouTubeIframeAPIReady() {
		player = new YT.Player('player', {
			width: '1',
			height: '',
			playerVars: {
				'autoplay': 0,
				'controls': 0,
				'disablekb': 1,
				'enablejsapi': 1,
			},
			events: {
				'onReady': onPlayerReady,
				'onStateChange': onPlayerStateChange,
				'onError': onPlayerError
			}
		});
	}

	function onPlayerReady(event) {
		title = event.target.getVideoData().title;
		player.setVolume(30);
	}

	function onPlayerStateChange(event) {
		if (event.data == YT.PlayerState.PLAYING) {
			title = event.target.getVideoData().title;
		}

		if (event.data == YT.PlayerState.ENDED) {
			musicIndex++;
			play();
		}
	}

	function onPlayerError(event) {
		switch (event.data) {
			case 2:
				logger.addToLog("The video id: " + vid + " seems invalid, wrong video id?");
				break;
			case 5:
				logger.addToLog("An HTML 5 player issue occured on video id: " + vid);
			case 100:
				logger.addToLog("Video " + vid + "does not exist, wrong video id?");
			case 101:
			case 150:
				$.post('https://rpuk_core/noembed', JSON.stringify({}));
				// logger.addToLog("Embedding for video id " + vid + " was not allowed.");
				// logger.addToLog("Please consider removing this video from the playlist.");
				break;
			default:
				logger.addToLog("An unknown error occured when playing: " + vid);
		}

		skip();
	}

	function skip() {
		play();
	}

	function play(id) {
		title = "n.a.";
		player.loadVideoById(id, 0, "tiny");
		player.playVideo();
	}

	function resume() {
		player.playVideo();
	}

	function pause() {
		player.pauseVideo();
	}

	function stop() {
		player.stopVideo();
	}

	function setVolume(volume) {
		player.setVolume(volume)
	}
});