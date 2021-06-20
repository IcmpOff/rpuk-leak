$(function () {
	document.onkeydown = function (event) {
		if (event.key == 'F5' || event.key == 'Escape') {
			$('.ui').hide();
			$.post('https://rpuk_guide/onCloseMenu');
		}
	};

	$("#btn-main").click(function () {
		$('#if-main').prop('src', 'https://wiki.roleplay.co.uk/GTA:Main_Page');
	});

	$("#btn-FivemR").click(function () {
		$('#if-main').prop('src', 'https://www.roleplay.co.uk/gtarprules/');
	});

	$("#btn-CommunityR").click(function () {
		$('#if-main').prop('src', 'https://www.roleplay.co.uk/community-rules/');
	});

	$("#btn-controls").click(function () {
		$('#if-main').prop('src', 'https://wiki.roleplay.co.uk/GTA:Controls');
	});

	$("#btn-FAQs").click(function () {
		$('#if-main').prop('src', 'https://wiki.roleplay.co.uk/GTA:FAQ');
	});

	$("#btn-community").click(function () {
		$('#if-main').prop('src', 'https://wiki.roleplay.co.uk/GTA:Wider_Community');

	});

	window.addEventListener('message', function (event) {
		switch (event.data.action) {
			case 'open':
				$('.ui').show();
				$('.ui').css('display', 'flex');
				break;

			case 'updateServerInfo':
				if (event.data.maxPlayers) {
					$('#max_players').html(event.data.maxPlayers);
				}

				if (event.data.playerCount) {
					$('#player_count').html(event.data.playerCount);
				}

				break;
			default:
				break;
		}
	}, false);
});