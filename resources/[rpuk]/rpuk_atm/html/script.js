var resourceName = 'rpuk_atm';
var atmType = 'normal';

$(function () {
	window.addEventListener('message', function (event) {
		if (event.data.action === 'openGeneral') {
			$('#general, #topbar').show();
			atmType = event.data.atmType;
			$('.curbalance').html(event.data.balance.toLocaleString());

			if (atmType == 'fund' && !event.data.canWithdraw) {
				$('#withdraw').hide();
			}
		} else if (event.data.action === 'setBalance' && atmType == 'normal') {
			$('.curbalance').html(event.data.balance);
		} else if (event.data.action === 'setPlayerName') {
			$('.username1').html(event.data.playerName);
		}
	});

	$('.btn-sign-out').click(function () {
		$('#general, #withdrawUI, #depositUI, #topbar').hide();
		$('body').removeClass('active');
		$.post('https://' + resourceName + '/onMenuClose');
		if (atmType == 'fund') { $('#withdraw').show(); }
	});

	$('.back').click(function () {
		$('#depositUI, #withdrawUI').hide();
		$('#amount').val('');
		$('#amountw').val('');
		$('#general').show();
	});

	$('#deposit').click(function () {
		$('#general').hide();
		$('#depositUI').show();
	});

	$('#withdraw').click(function () {
		$('#general').hide();
		$('#withdrawUI').show();
	});

	$('#deposit1').submit(function (e) {
		e.preventDefault(); // Prevent form from submitting
		$.post('https://' + resourceName + '/deposit', JSON.stringify({
			amount: $('#amount').val(),
			atmType: atmType
		}), function (newBalance) {
			$('.curbalance').html(newBalance.toLocaleString());
			$('#depositUI').hide();
			$('#general').show();
			$('#amount').val('');
		});
	});

	$('#withdraw1').submit(function (e) {
		e.preventDefault(); // Prevent form from submitting
		$.post('https://' + resourceName + '/withdraw', JSON.stringify({
			amount: $('#amountw').val(),
			atmType: atmType
		}), function (newBalance) {
			$('.curbalance').html(newBalance.toLocaleString());
			$('#withdrawUI').hide();
			$('#general').show();
			$('#amountw').val('');
		});
	});

	document.onkeyup = function (event) {
		if (event.key == 'Escape') {
			$('#general, #withdrawUI, #depositUI, #topbar').hide();
			$('body').removeClass('active');
			$.post('https://' + resourceName + '/onMenuClose');
			if (atmType == 'fund') { $('#withdraw').show(); }
		}
	};
});