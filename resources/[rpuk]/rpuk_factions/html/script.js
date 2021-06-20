window.addEventListener('message', (event) => {
	if (event.data.name == 'openFactionManagment') {
		openFactionManagment(event.data.isJob);
	}
});

function openFactionManagment(isJob) {
	$.confirm({
		title: 'Faction Managment',
		icon: 'fa fa-user-tag',
		type: 'blue',
		animation: 'scale',
		content: '',
		buttons: {
			existingEmployees: {
				text: 'Manage Employees',
				action: function () {
					openEmployeesJobManagmentMenu(isJob);
					return false;
				}
			}, employNewPlayer: {
				text: 'Employ new player',
				action: function () {
					openEmployNewPlayerMenu();
					return false;
				}
			}, closeMenu: {
				text: 'Close',
				action: function () { $.post('https://rpuk_factions/onMenuClose', {}); }
			}
		},
	});
}

function openEmployeesJobManagmentMenu(isJob) {
	$.confirm({
		title: 'Employees Managment',
		icon: 'fa fa-user-tag',
		type: 'blue',
		animation: 'scale',
		content: function () {
			this.showLoading(true);
			var self = this;

			$.post('https://rpuk_factions/getEmployeeList', {}, function (employeeList) {
				var htmlEmployeeList = '<option value=0>None</option>';

				$.each(employeeList, function (k, v) {
					htmlEmployeeList += `<option data-firstname="${v.firstname}" data-lastname="${v.lastname}" data-rank="${v.joblevel}" value=${v.rpuk_charid}>${v.firstname} ${v.lastname}</option>`;
				});

				if (isJob) {
					self.setContent('<select name="employee" id="employee" onchange="openEmployeeJobDetailsMenu();" onfocus="this.selectedIndex = -1;">' +
						htmlEmployeeList +
						'</select>');
				} else {
					self.setContent('<select name="employee" id="employee" onchange="openEmployeeMutexDetailsMenu();" onfocus="this.selectedIndex = -1;">' +
						htmlEmployeeList +
						'</select>');
				}

				self.hideLoading(true);
			});
		},
		buttons: {
			closeMenu: { text: 'Back' }
		}
	});
}

function openEmployeeJobDetailsMenu() {
	var $employee = $('#employee :selected');
	var isEditing = true;

	if ($employee.val() > 0) {
		$.confirm({
			title: 'Employee Details',
			icon: 'fa fa-user-tag',
			type: 'blue',
			animation: 'scale',
			content: function () {
				this.showLoading(true);
				var self = this;

				$.post('https://rpuk_factions/getEmployeeDetails', JSON.stringify({ characterId: parseInt($employee.val()) }), function (jobData) {
					self.setContent(`<h4>Employee Information</h4>Name: ${$employee.data('firstname')} ${$employee.data('lastname')}` +
						`<br><label for="rank">Rank Level</label>` +
						`<input type="number" class="unit" id="rank" name="rank" value="${$employee.data('rank')}" min=0 max=10 disabled><br><br>`);

					if (jobData) {
						self.setContentAppend(`<br><br><h4>Specialized Units</h4>`);

						$.each(jobData, function (index, data) {
							self.setContentAppend(`<label for="${data.name}">${data.label}</label>` +
								`<input type="number" class="unit" id="${data.name}" name="${data.label}" value="${data.value}" min=0 max=5 disabled><br><br>`);
						});
					}

					self.hideLoading(true);
				});
			},
			buttons: {
				setRank: {
					text: 'Edit',
					action: function () {
						if (isEditing) {
							this.buttons.setRank.setText('Save');
							$('.unit').prop('disabled', false);
							isEditing = false;
						} else {
							var self = this;
							var newFlags = {};
							self.showLoading(true);
							self.buttons.setRank.setText('Edit');
							$('.unit').prop('disabled', true);
							isEditing = true;

							$.each($('.unit'), function (index, $object) {
								newFlags[$object.id] = parseInt($object.value);
							});

							$.post('https://rpuk_factions/updateFlagsForPlayer', JSON.stringify({ characterId: parseInt($employee.val()), newFlags: newFlags }), function (success) {
								if (success) {
									showBasicDismissDialog('Employee Details Dialog', 'fa fa-user-tag', 'green', 'Updating player flags was successful');
									$employee.data('rank', parseInt(newFlags.rank));
								} else {
									showBasicDismissDialog('Employee Details Dialog', 'fa fa-exclamation-triangle', 'orange', 'Updating player flags was not successful');
								}

								self.hideLoading(true);
							});
						}

						return false;
					}
				},
				kickPlayer: {
					text: 'Remove Access',
					action: function () {
						var self = this;
						self.showLoading(true);

						$.post('https://rpuk_factions/removePlayerAccessFromFaction', JSON.stringify({ characterId: parseInt($employee.val()) }), function (success) {
							if (success) {
								showBasicDismissDialog('Employee Details Dialog', 'fa fa-user-tag', 'green', 'Removing player access was successful');
								$employee.remove();
							} else {
								showBasicDismissDialog('Employee Details Dialog', 'fa fa-exclamation-triangle', 'orange', 'Removing player access was not successful');
							}

							self.hideLoading(true);
						});
					}
				},
				closeMenu: { text: 'Back' }
			}
		});
	}
}

function openEmployeeMutexDetailsMenu() {
	var $employee = $('#employee :selected');
	var isEditing = true;

	if ($employee.val() > 0) {
		$.confirm({
			title: 'Employee Details',
			icon: 'fa fa-user-tag',
			type: 'blue',
			animation: 'scale',
			content: `<h4>Employee Information</h4>Name: ${$employee.data('firstname')} ${$employee.data('lastname')}` +
				`<br><label for="rank">Rank Level</label>` +
				`<input type="number" class="unit" id="rank" name="rank" value="${$employee.data('rank')}" min=0 max=10 disabled><br><br>`,
			buttons: {
				setRank: {
					text: 'Edit',
					action: function () {
						if (isEditing) {
							this.buttons.setRank.setText('Save');
							$('.unit').prop('disabled', false);
							isEditing = false;
						} else {
							var self = this;
							var newLevel = parseInt($('.unit').val());
							self.showLoading(true);
							self.buttons.setRank.setText('Edit');
							$('.unit').prop('disabled', true);
							isEditing = true;

							$.post('https://rpuk_factions/updateMutexJobForPlayer', JSON.stringify({ characterId: parseInt($employee.val()), level: newLevel }), function (success) {
								if (success) {
									showBasicDismissDialog('Employee Details Dialog', 'fa fa-user-tag', 'green', 'Updating player data was successful');
									$employee.data('rank', newLevel);
								} else {
									showBasicDismissDialog('Employee Details Dialog', 'fa fa-exclamation-triangle', 'orange', 'Updating player data was not successful');
								}

								self.hideLoading(true);
							});
						}

						return false;
					}
				},
				kickPlayer: {
					text: 'Remove Access',
					action: function () {
						var self = this;
						self.showLoading(true);

						$.post('https://rpuk_factions/removePlayerAccessFromFaction', JSON.stringify({ characterId: parseInt($employee.val()) }), function (success) {
							if (success) {
								showBasicDismissDialog('Employee Details Dialog', 'fa fa-user-tag', 'green', 'Removing player access was successful');
								$employee.remove();
							} else {
								showBasicDismissDialog('Employee Details Dialog', 'fa fa-exclamation-triangle', 'orange', 'Removing player access was not successful');
							}

							self.hideLoading(true);
						});
					}
				},
				closeMenu: { text: 'Back' }
			}
		});
	}
}

function openEmployNewPlayerMenu() {
	$.confirm({
		title: 'Employ New Player',
		icon: 'fa fa-user-plus',
		type: 'blue',
		animation: 'scale',
		content: 'Employ a player by entering their character id.' +
			'<form action="" class="formName">' +
			'<div class="form-group">' +
			'<input type="number" id="characterID" placeholder="Character ID">' +
			'</div>' +
			'</form>',
		buttons: {
			employ: {
				text: 'Employ',
				action: function () {
					var self = this;
					var characterId = parseInt($('#characterID').val());
					self.showLoading(true);

					$.post('https://rpuk_factions/employPlayerByCharacterId', JSON.stringify({ characterId: characterId }), function (success) {
						if (success) {
							showBasicDismissDialog('Employ New Player Dialog', 'fa fa-user-plus', 'green', 'Employing player was successful');
						} else {
							showBasicDismissDialog('Employ New Player Dialog', 'fa fa-exclamation-triangle', 'orange', 'Employing player was not successful');
						}

						self.hideLoading(true);
					});

					return false;
				}
			}, close: { text: 'Back' }
		}
	});
}

function showBasicDismissDialog(title, icon, type, content) {
	$.confirm({
		title: title,
		icon: icon,
		type: type,
		animation: 'scale',
		content: content,
		buttons: { close: {} }
	});
}