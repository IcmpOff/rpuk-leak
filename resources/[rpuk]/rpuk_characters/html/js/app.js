var jobLabels = {
	'police': 'Police Service',
	'ambulance': 'Ambulance Service',
	'mechanic': 'Mechanic & Impound Service',
	'taxi': 'Taxi Service',
	'gruppe6': 'Gruppe Sechs',
	'court': 'Los Santos Ministry Of Justice',
}

$(".character-box").hover(
	function () {
		$(this).css({
			"background": "rgba(42, 125, 193, 1.0)",
			"transition": "200ms",
		});
	}, function () {
		$(this).css({
			"background": "rgba(0,0,0,0.6)",
			"transition": "200ms",
		});
	}
);

$(".character-box").click(function () {
	var activeCharacterIndex = $('.active-char').attr("data-characterIndex");

	// click twice to unselect
	if (activeCharacterIndex && activeCharacterIndex == $(this).attr("data-characterIndex")) {
		$(".character-box").removeClass('active-char');
		$(".character-buttons").css({ "display": "none" });
	} else {
		$(".character-box").removeClass('active-char');
		$(this).addClass('active-char');
		$(".character-buttons").css({ "display": "block" });

		if ($(this).attr("data-doesCharacterExist") == 'true') {
			$("#delete").css({ "display": "block" });
		} else {
			$("#delete").css({ "display": "none" });
		}
	}
});

$("#play-char").click(function () {
	var _isNameWiped = ($('.active-char').attr("data-isNameWiped") == 'true');

	$.post("https://rpuk_characters/choosenCharacter", JSON.stringify({
		characterIndex: parseInt($('.active-char').attr("data-characterIndex")),
		doesCharacterExist: $('.active-char').attr("data-doesCharacterExist"),
		isNameWiped: _isNameWiped
	}));

	closeUI();
});

$("#delete").click(function () {
	var characaterIndex = $('.active-char').attr("data-characterIndex");
	$('.main-container').css({ "display": "none" });
	$(".character-buttons").css({ "display": "none" });
	$.confirm({
		title: 'There is no going back!',
		icon: 'fa fa-trash',
		animation: 'scale',
		content: 'If you delete your character it will be gone forever, and it cannot be undone.',
		type: 'red',
		autoClose: 'cancelAction|8000',
		buttons: {
			deleteUser: {
				text: 'Delete',
				btnClass: 'btn-red',
				action: function () {
					var self = this;
					self.showLoading(true);

					$.post("https://rpuk_characters/deleteCharacter", JSON.stringify({
						characterIndex: parseInt(characaterIndex)
					}), function (success) {
						self.buttons.cancelAction.setText('Close');

						if (success) {
							$(`[data-characterIndexOld=1]`).html('<h3 class="character-fullname"><i class="fas fa-plus"></i></h3><p class="character-info-new">Create new character</p>')
								.attr("data-doesCharacterExist", false)
								.attr("data-isNameWiped", false);

							$(".character-box").removeClass('active-char');
							$(".character-buttons").css({ "display": "none" });

							self.buttons.deleteUser.hide();
							self.setTitle('Deleted Character');
							self.setContent('Character deletion was successful');
						} else {
							self.buttons.deleteUser.setText('Try Again');
							self.setTitle('Character Deletion Failed');
							self.setContent('Character deletion was not successful');
						}

						self.hideLoading(true);
					});

					return false;
				}
			},
			cancelAction: {
				text: 'Cancel',
				action: function () {
					$('.main-container').css({ "display": "block" });
					$.post('https://rpuk_characters/keepFocus');
				}
			}
		}
	});
});

function randomNumber(min, max) { return Math.floor(Math.random() * (max - min)) + min; }

const capitalize = words => words.split(' ').map(w => w.substring(0, 1).toUpperCase() + w.substring(1)).join(' ')

function showUI(data) {
	$('.main-container').css({ "display": "block" });
	$(".character-buttons").css({ "display": "none" });
	$(".character-box").removeClass('active-char');


	if (data.character) {
		var char = data.character;
		var gender;
		var jailStatus;
		var jobTag = '';
		var healthTag;
		var bankBalance = 0;
		var moneyBalance = 0;
		var isNameWiped = false;
		var jobLabel = jobLabels[char.job];

		try {
			var accounts = JSON.parse(char.accounts);

			if (accounts.bank) { bankBalance = accounts.bank.toLocaleString(); }
			if (accounts.money) { moneyBalance = accounts.money.toLocaleString(); }
		} catch (exception) { }

		try {
			var skin = JSON.parse(char.skin);
			gender = skin.sex == 0 && 'Male' || 'Female';
		} catch (exception) {
			gender = '<span style="color:orange;">Skin is Corrupted</span>';
		}

		char.jailed > 0 ? jailStatus = 'Yes' : jailStatus = 'No';

		if (jobLabel) { jobTag = `<p>Job: ${jobLabel}</p>`; }

		if (char.dead) {
			healthTag = 'Dead';
		} else {
			var healthPercent = Math.round(char.health / 200 * 100);
			healthTag = `${healthPercent} %`;
		}

		if (char.firstname == '' || char.lastname == '') {
			char.firstname = '<span style="color:orange;">Name is Wiped</span>';
			char.lastname = '';
			isNameWiped = true;
		}

		$(`[data-characterIndexOld=1]`).html(`
			<h3 class="character-fullname">${char.firstname} ${char.lastname}</h3>

			<div class="character-info">
				<p>Cash: £${moneyBalance}</span></p>
				<p>Bank: £${bankBalance}</span></p>
				<p>Health: ${healthTag}</p>
				<p>Armour: ${Math.round(char.armour / 100 * 100)} %</p>
				${jobTag}
				<p>Gender: ${gender}</p>
				<p>Imprisoned: ${jailStatus}</p>
				<p>Char ID: ${char.rpuk_charid}</p>
			</div>`)
				.attr("data-doesCharacterExist", true)
				.attr("data-characterIndex", char.character_index)
				.attr("data-isNameWiped", isNameWiped);
	} else {
		$(`[data-characterIndexOld=1]`).html('<h3 class="character-fullname"><i class="fas fa-plus"></i></h3><p class="character-info-new">Create new character</p>')
				.attr("data-doesCharacterExist", false)
				.attr("data-isNameWiped", false)
				.attr("data-characterIndex", data.character_index);
		$(".character-buttons").css({ "display": "none" });
		$(".character-box").removeClass('active-char');
	}
};

function closeUI() {
	$('.main-container').css({ "display": "none" });
	$(".character-box").removeClass('active-char');
	$(".character-buttons").css({ "display": "none" });
};

function playIntro() {
	var introIndex = randomNumber(1, 5);
	var audio = new Audio(`nui://rpuk_characters/html/intro/intro${introIndex}.ogg`);
	audio.volume = audio.volume / 3;
	audio.play();
}

function chooseSpawnLocation() {
	$.confirm({
		title: 'Choose Spawn Location',
		icon: 'fa fa-map',
		animation: 'scale',
		content: 'If you were in a roleplay scenario previously and had to relog or crashed, then please go back to that scenario.',
		type: 'blue',
		buttons: {
			jobSpawn: {
				text: 'Job Hub',
				action: function () {
					$.post("https://rpuk_characters/spawnLocationChoosen", JSON.stringify({ respawnAtLastCoords: false }));
				}
			},

			lastCoords: {
				text: 'Last Location',
				action: function () {
					$.post("https://rpuk_characters/spawnLocationChoosen", JSON.stringify({ respawnAtLastCoords: true }));
				}
			}
		}
	});
}

function createCharacter(characterIndex) {
	$.confirm({
		title: 'Character Creation',
		icon: 'fa fa-plane-arrival',
		animation: 'scale',
		type: 'blue',
		content: '' +
			'<form action="" class="formName">' +
			'<div class="form-group">' +
			'' +
			'<input type="text" placeholder="First name" class="firstname form-control text-capitalize" required />' +
			'<input type="text" placeholder="Last name" class="lastname form-control text-capitalize" required /><br>' +
			'<input type="number" placeholder="Age (18-100 years old)" class="age form-control" required />' +
			'<input type="number" placeholder="Height (140-200 cm)" class="height form-control" required /><br>' +
			'<input type="radio" name="gender" value="male" class="male form-control" required /> Male' +
			'<input type="radio" name="gender" value="female" class="female form-control" required /> Female<br><br>' +
			'<label><input type="checkbox" id="rules-gtarp"> I have read the GTA RP Rules</label>' +
			'<label><input type="checkbox" id="rules-community"> I have read the Community Rules</label>' +
			'</div>' +
			'</form>',
		buttons: {
			formSubmit: {
				text: 'Create',
				action: function () {
					$.post('https://rpuk_characters/characterCreated', JSON.stringify({
						firstName: capitalize(this.$content.find('.firstname').val()),
						lastName: capitalize(this.$content.find('.lastname').val()),
						age: this.$content.find('.age').val(),
						height: this.$content.find('.height').val(),
						gender: $(".formName input[type='radio']:checked").val() || 'none',
						characterIndex: parseInt(characterIndex),
						gtaRulesChecked: this.$content.find('#rules-gtarp').prop('checked'),
						communityRulesChecked: this.$content.find('#rules-community').prop('checked'),
						doesCharacterExist: false
					}), function (success) {
						if (success) { jconfirm.instances[0].close(); }
					});

					return false;
				}
			}, rulesButton: {
				text: 'Read Rules',
				action: function () {
					$.post('https://rpuk_characters/openGuide');
					return false;
				}
			}, cancelAction: {
				text: 'Cancel',
				action: function () {
					$('.main-container').css({ "display": "block" });
					$.post('https://rpuk_characters/keepFocus');
				}
			}
		},
		onContentReady: function () {
			// bind to events
			var jc = this;
			this.$content.find('form').on('submit', function (e) {
				// if the user submits the form by pressing enter in the field.
				e.preventDefault();
				jc.$$formSubmit.trigger('click'); // reference the button and click it
			});
		}
	});
}

function showNamePrompt(characterIndex) {
	$.confirm({
		title: 'Character Name Creation',
		icon: 'fa fa-user-tag',
		animation: 'scale',
		type: 'orange',
		content: 'Your character name has been wiped by staff because it broke the <strong>G5.1</strong> rule. Read our rules before you proceed.<br><br>' +
			'Consistent rule breaks may lead to further action on your account.<br><br>' +
			'<form action="" class="formName">' +
			'<div class="form-group">' +
			'' +
			'<input type="text" placeholder="First name" class="firstname form-control text-capitalize" required />' +
			'<input type="text" placeholder="Last name" class="lastname form-control text-capitalize" required /><br>' +
			'<label><input type="checkbox" id="rules-gtarp"> I have read the GTA RP Rules</label>' +
			'<label><input type="checkbox" id="rules-community"> I have read the Community Rules</label>' +
			'</div>' +
			'</form>',
		buttons: {
			formSubmit: {
				text: 'Update',
				action: function () {
					$.post('https://rpuk_characters/characterCreated', JSON.stringify({
						firstName: capitalize(this.$content.find('.firstname').val()),
						lastName: capitalize(this.$content.find('.lastname').val()),
						characterIndex: parseInt(characterIndex),
						gtaRulesChecked: this.$content.find('#rules-gtarp').prop('checked'),
						communityRulesChecked: this.$content.find('#rules-community').prop('checked'),
						doesCharacterExist: true,
						updateNames: true
					}), function (success) {
						if (success) { jconfirm.instances[0].close(); }
					});

					return false;
				}
			}, rulesButton: {
				text: 'Read Rules',
				action: function () {
					$.post('https://rpuk_characters/openGuide');
					return false;
				}
			}, cancelAction: {
				text: 'Cancel',
				action: function () {
					$('.main-container').css({ "display": "block" });
					$.post('https://rpuk_characters/keepFocus');
				}
			}
		},
		onContentReady: function () {
			// bind to events
			var jc = this;
			this.$content.find('form').on('submit', function (e) {
				// if the user submits the form by pressing enter in the field.
				e.preventDefault();
				jc.$$formSubmit.trigger('click'); // reference the button and click it
			});
		}
	});
}

function showVoiceWarning(data) {
	$.confirm({
		title: 'Voice Chat Not Enabled',
		icon: 'fa fa-microphone-alt-slash',
		animation: 'scale',
		type: 'orange',
		content: 'Voice Chat is disabled by default in FiveM. In order to play on roleplay.co.uk you must manually enable it.<br><br>We will open the pause menu for you.<ol><li>Select Settings</li><li>Select Voice Chat</li><li>Enable "Voice Chat Enabled"</li><li>Enable "Microphone Enabled"</li><li>Close the pause menu</li></ol>',
		buttons: {
			openPauseMenu: {
				text: 'Open Pause Menu',
				action: function () {
					$.post("https://rpuk_characters/openPauseMenu", {}, function (isVoiceActivated) {
						if (isVoiceActivated) {
							showUI(data);
						} else {
							showVoiceWarning(data);
						}
					});
				}
			}
		}
	});
}

window.addEventListener('message', function (event) {
	switch (event.data.action) {
		case 'openUI':
			if (event.data.isVoiceActivated) {
				showUI(event.data);
			} else {
				showVoiceWarning(event.data);
			}

			break;

		case 'playIntro':
			playIntro();
			break;

		case 'closeUI':
			closeUI();
			break;

		case 'chooseSpawnLocation':
			chooseSpawnLocation();
			break;

		case 'createCharacter':
			createCharacter(event.data.characterIndex);
			break;

		case 'showNamePrompt':
			showNamePrompt(event.data.characterIndex);
			break;
	}
});