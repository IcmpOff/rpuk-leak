var active = false;

var gang_name
var lead_members
var lead_ranks
var default_perms
var poss_invites
var pending_invites

$(function () {
	window.addEventListener('message', function (event) {
		document.body.style.display = event.data.enable ? "block" : "none";
		if (event.data.type == "create_menu") {
			if (active === false) {
				active = true;
				pending_invites = event.data.pending_invites
				create_menu()
			}
		} else if (event.data.type == "lead_menu") {
			if (active === false) {
				active = true;
				gang_name = event.data.gang_name
				lead_members = event.data.gang_members
				lead_ranks = event.data.gang_ranks
				poss_invites = event.data.no_gangs
				default_perms = event.data.default_permissions
				lead_menu()
			}
		} else if (event.data.type == "leave_menu") {
			if (active === false) {
				active = true;
				leave_menu()
			}
		}
	});
});

var selectedMember
function fetchSelectGangMember() {
	var x = document.getElementById("gang_lead_member_list").value;
	selectedMember = x
}

var selectedInvite
function fetchSelectInviteMember() {
	var x = document.getElementById("gang_lead_invite_list").value;
	selectedInvite = x
}

var selectedRank
function fetchSelectGangRank() {
	var x = document.getElementById("gang_lead_rank_list").value;
	selectedRank = x
}

var selectedRankProp
function fetchSelectGangPropRank() {
	var x = document.getElementById("gang_lead_rankProp_list").value;
	selectedRankProp = x
}

var selectedRankPerm
function fetchSelectGangRankPerm() {
	var x = document.getElementById("gang_lead_rankPerm_list").value;
	selectedRankPerm = x
}

var selectedPendingInvite
function fetchSelectPendingInvite() {
	var x = document.getElementById("gang_pending_invites").value;
	selectedPendingInvite = x
}

function create_menu() {
	$.confirm({
		title: 'RPUK Gang Menu',
		icon: 'fas fa-cannabis fa-spin',
		type: 'green',
		columnClass: 'medium',
		alignMiddle: true,
		closeIcon: true,
		closeIcon: function () {
			$.post('https://rpuk_gangs/escape', JSON.stringify({}));
			active = false;
		},
		content: 'Welcome to the Roleplay.co.uk gang interaction menu, here you can join, create, and find out information about the gang features!<br>Select from the options below to proceed.<br><br><strong>Ensure you are not in active roleplay scenario.</strong>' +
			'<br><br><strong>Pending Gang Invites</strong>' +
			'<select name="cars" id="gang_pending_invites" class="form-control ng-pristine ng-untouched ng-valid ng-not-empty" onchange="fetchSelectPendingInvite()">' +
			'<option value="">None</option>' +
			'</select>',
		buttons: {
			acceptPendingInvite: {
				text: 'Accept Invite',
				btnClass: 'btn-blue',
				action: function () {
					if (!selectedPendingInvite) {
						$.alert('Select a pending invite!');
						return false;
					}
					$.post('https://rpuk_gangs/accept_invite', JSON.stringify({ selectedPendingInvite }), function (postResult) {
						if (postResult.result == true) {
							$.alert({
								title: 'Gang Invite Accepted!',
								content: postResult.message,
								icon: 'fas fa-cannabis fa-spin',
								type: 'green',
								columnClass: 'medium',
								buttons: {
									next: function () {
										$.post('https://rpuk_gangs/escape', JSON.stringify({}));
										active = false;
									}
								}
							});
						} else {
							$.alert({
								title: 'Gang Invite Failed!',
								content: postResult.message,
								icon: 'fas fa-cannabis fa-spin',
								type: 'red',
								columnClass: 'medium',
								buttons: {
									next: function () {
										$.post('https://rpuk_gangs/escape', JSON.stringify({}));
										active = false;
									}
								}
							});

						}
					});
				}
			},
			createGang: {
				text: 'Create Gang',
				btnClass: 'btn-success',
				action: function () {
					$.confirm({
						title: 'Create a Gang',
						typeAnimated: true,
						icon: 'fas fa-cannabis fa-spin',
						backgroundDismiss: true,
						autoClose: true,
						type: 'green',
						columnClass: 'medium',
						content: '' +
							'<form action="" class="formName">' +
							'<div class="form-group">' +
							'<label>By creating a gang you agree to all the server rules, found on the website roleplay.co.uk</label><label>For additional information for gang features please visit https://wiki.roleplay.co.uk/ prior to creating your gang!</label>' +
							'<input type="text" placeholder="Gang Name" class="name form-control" required />' +
							'</div>' +
							'</form>',
						buttons: {
							formSubmit: {
								text: 'Create Gang',
								btnClass: 'btn-success',
								action: function () {
									var name = this.$content.find('.name').val();
									if (!name) {
										$.alert('Please provide a valid gang name');
										return false;
									}

									$.post('https://rpuk_gangs/create', JSON.stringify({ name }), function (ret_data) {
										if (ret_data.result == true) {
											$.alert({
												title: 'Gang Creation Successful!',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'green',
												columnClass: 'medium',
												buttons: {
													next: function () {
														$.post('https://rpuk_gangs/escape', JSON.stringify({}));
														active = false;
													}
												}
											});
										} else {
											$.alert({
												title: 'Gang Creation Unsuccessful!',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'red',
												columnClass: 'medium',
												buttons: {
													next: function () {
														$.post('https://rpuk_gangs/escape', JSON.stringify({}));
														active = false;
													}
												}
											});
										}
									});

								}
							},
							cancel: function () {
								$.post('https://rpuk_gangs/escape', JSON.stringify({}));
								active = false;
							},
						},
						onContentReady: function () {
							var jc = this;
							this.$content.find('form').on('submit', function (e) {
								// if the user submits the form by pressing enter in the field.
								e.preventDefault();
								jc.$$formSubmit.trigger('click'); // reference the button and click it
							});
						}
					});
				}
			},
		},
		onContentReady: function () {
			$('#gang_pending_invites').empty()
			$('#gang_pending_invites').append('<option value=""></option>')
			for (let i in pending_invites) {
				let invite = pending_invites[i]
				$('#gang_pending_invites').append('<option value="' + invite.gang_id + '">' + invite.gang_name + '</option>')
			}
		}
	});
}

function leave_menu() {
	$.confirm({
		title: 'RPUK Gang Menu',
		icon: 'fas fa-cannabis fa-spin',
		type: 'green',
		content: 'Welcome to the Roleplay.co.uk gang interaction menu, as you are a member of a gang. You can use this menu to leave.<br><br><strong>Ensure you are not in active roleplay scenario.</strong>',
		columnClass: 'medium',
		alignMiddle: true,
		closeIcon: true,
		closeIcon: function () {
			$.post('https://rpuk_gangs/escape', JSON.stringify({}));
			active = false;
		},
		buttons: {
			leaveGang: {
				text: 'Leave Gang',
				btnClass: 'btn-red',
				action: function () {
					$.confirm({
						title: 'RPUK Gang Menu',
						icon: 'fas fa-cannabis fa-spin',
						type: 'red',
						content: 'Welcome to the Roleplay.co.uk gang interaction menu, as you are a member of a gang. You can use this menu to leave.<br><br><strong>Ensure you are not in active roleplay scenario.</strong>',
						columnClass: 'medium',
						alignMiddle: true,
						autoClose: 'cancel|10000',
						buttons: {
							leaveGang: {
								text: 'Leave Gang',
								btnClass: 'btn-red',
								action: function () {

									$.post('https://rpuk_gangs/leave', JSON.stringify({ name }), function (ret_data) {
										if (ret_data.result == true) {
											$.alert({
												title: 'You left the gang!',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'green',
												columnClass: 'medium',
												buttons: {
													next: function () {
														//$.post('https://rpuk_gangs/escape', JSON.stringify({}));
														create_menu()
														active = false;
													}
												}
											});
										} else {
											$.alert({
												title: 'Something went wrong...',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'red',
												columnClass: 'medium',
												buttons: {
													next: function () {
														$.post('https://rpuk_gangs/escape', JSON.stringify({}));
														active = false;
													}
												}
											});
										}
									});
								}
							},
							cancel: function () {
								leave_menu()
							}
						}
					});


				}
			},
		}
	});
}

function lead_menu() {
	$.confirm({
		title: 'RPUK Gang Leadership (' + gang_name + ')',
		icon: 'fas fa-cannabis fa-spin',
		type: 'green',
		content: 'Welcome to the Roleplay.co.uk gang leadership menu<br><br><strong>Ensure you are not in active roleplay scenario.</strong>',
		columnClass: 'medium',
		alignMiddle: true,
		closeIcon: true,
		closeIcon: function () {
			$.post('https://rpuk_gangs/escape', JSON.stringify({}));
			active = false;
		},
		buttons: {
			members: {
				text: 'Gang Members',
				btnClass: 'btn-success',
				action: function () {
					lead_menu_members()
				}
			},
			invite: {
				text: 'Invite Members',
				btnClass: 'btn-success',
				action: function () {
					lead_menu_invite()
				}
			},
			ranks: {
				text: 'Ranks / Permissions',
				btnClass: 'btn-success',
				action: function () {
					lead_menu_ranks()
				}
			},
			disband: { // just make them leave
				text: 'Leave Gang',
				btnClass: 'btn-danger',
				action: function () {
					leave_menu()
				}
			},
		}
	});
}

function lead_menu_members() {
	$.confirm({
		title: 'RPUK Gang Members (' + gang_name + ')',
		icon: 'fas fa-cannabis fa-spin',
		type: 'green',
		columnClass: 'medium',
		alignMiddle: true,
		closeIcon: true,
		closeIcon: function () {
			$.post('https://rpuk_gangs/escape', JSON.stringify({}));
			active = false;
		},
		content: '' +
			'<select name="cars" id="gang_lead_member_list" class="form-control ng-pristine ng-untouched ng-valid ng-not-empty" onchange="fetchSelectGangMember()">' +
			'<option value="">None</option>' +
			'</select>',
		buttons: {

			changeRank: {
				text: 'Change Member Rank',
				btnClass: 'btn-success',
				action: function () {
					if (!selectedMember) { // selectedMember = id
						$.alert('Please Select a Member');
						return false;
					}
					lead_menu_changeMemberRank(selectedMember)
				}
			},

			kickMember: {
				text: 'Kick Member',
				btnClass: 'btn-red',
				action: function () {
					if (!selectedMember) { // selectedMember = id
						$.alert('Please Select a Member');
						return false;
					}
					$.confirm({
						title: 'Kick ' + lead_members[selectedMember].name,
						icon: 'fas fa-cannabis fa-spin',
						type: 'red',
						content: '<strong>Ensure you are not in active roleplay scenario.</strong>',
						columnClass: 'medium',
						alignMiddle: true,
						autoClose: 'cancel|10000',
						buttons: {
							kickMember2: {
								text: 'Kick Member',
								btnClass: 'btn-red',
								action: function () {

									$.post('https://rpuk_gangs/kick', JSON.stringify({ selectedMember }), function (ret_data) {
										if (ret_data.result == true) {
											$.alert({
												title: 'Gang member kicked!',
												content: "Member Kicked",//ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'green',
												columnClass: 'medium',
												buttons: {
													next: function () {
														//$.post('https://rpuk_gangs/escape', JSON.stringify({}));
														lead_members = JSON.parse(ret_data.gang_members)
														lead_menu_members()
														active = false;
													}
												}
											});
										} else {
											$.alert({
												title: 'Something went wrong...',
												content: "Something went wrong",//ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'red',
												columnClass: 'medium',
												buttons: {
													next: function () {
														$.post('https://rpuk_gangs/escape', JSON.stringify({}));
														active = false;
													}
												}
											});
										}
									});

								}
							},
							cancel: function () {
								lead_menu_members()
							}
						}
					});

				}
			},

			goBack: {
				text: 'Return',
				btnClass: 'btn-orange',
				action: function () {
					lead_menu()
				}
			},
		},

		onContentReady: function () {
			$('#gang_lead_member_list').empty()
			$('#gang_lead_member_list').append('<option value=""></option>')
			for (let i in lead_members) {
				let member = lead_members[i]
				if (member.rank !== 1) { // exclude the leader from the member list
					var rank_label = "RANK NOT FOUND"
					if (lead_ranks[member.rank - 1]) { rank_label = lead_ranks[member.rank - 1].label }
					$('#gang_lead_member_list').append('<option value="' + i + '">' + member.name + ' (' + rank_label + ')</option>')
				}
			}
		}
	});
}

function lead_menu_invite() {
	$.confirm({
		title: 'RPUK Invite Members (' + gang_name + ')',
		icon: 'fas fa-cannabis fa-spin',
		type: 'green',
		columnClass: 'medium',
		alignMiddle: true,
		closeIcon: true,
		closeIcon: function () {
			$.post('https://rpuk_gangs/escape', JSON.stringify({}));
			active = false;
		},
		content: '' +
			'<select name="cars" id="gang_lead_invite_list" class="form-control ng-pristine ng-untouched ng-valid ng-not-empty" onchange="fetchSelectInviteMember()">' +
			'<option value="">None</option>' +
			'</select>',
		buttons: {
			inviteMember: {
				text: 'Invite Member',
				btnClass: 'btn-success',
				action: function () {
					if (!selectedInvite) { // selectedMember = id
						$.alert('Please Select a Member');
						return false;
					}
					$.post('https://rpuk_gangs/invite', JSON.stringify({ selectedInvite }), function (ret_data) {
						if (ret_data.result == true) {
							$.alert({
								title: 'Member Invited!',
								content: ret_data.message,
								icon: 'fas fa-cannabis fa-spin',
								type: 'green',
								columnClass: 'medium',
								buttons: {
									next: function () {
										//$.post('https://rpuk_gangs/escape', JSON.stringify({}));
										poss_invites = JSON.parse(ret_data.no_gangs)
										lead_menu_invite()
										active = false;
									}
								}
							});
						} else {
							$.alert({
								title: 'Something went wrong...',
								content: "Something went wrong",//ret_data.message,
								icon: 'fas fa-cannabis fa-spin',
								type: 'red',
								columnClass: 'medium',
								buttons: {
									next: function () {
										$.post('https://rpuk_gangs/escape', JSON.stringify({}));
										active = false;
									}
								}
							});
						}

					});

				}
			},
			goBack: {
				text: 'Return',
				btnClass: 'btn-orange',
				action: function () {
					lead_menu()
				}
			},
		},

		onContentReady: function () {
			$('#gang_lead_invite_list').empty()
			$('#gang_lead_invite_list').append('<option value=""></option>')
			for (let i in poss_invites) {
				let invite = poss_invites[i]
				$('#gang_lead_invite_list').append('<option value="' + i + '">' + invite.name + ' (No Affiliation)</option>')
			}
		}
	});
}

function lead_menu_changeMemberRank(charID) {
	var rank_label = "RANK NOT FOUND"
	if (lead_ranks[lead_members[charID].rank - 1]) { rank_label = lead_ranks[lead_members[charID].rank - 1].label }
	$.confirm({
		title: "Change " + lead_members[charID].name + "'s Rank (Currently: " + rank_label + ")",
		icon: 'fas fa-cannabis fa-spin',
		type: 'green',
		columnClass: 'medium',
		alignMiddle: true,
		closeIcon: true,
		closeIcon: function () {
			$.post('https://rpuk_gangs/escape', JSON.stringify({}));
			active = false;
		},
		content: '' +
			'<select name="cars" id="gang_lead_rank_list" class="form-control ng-pristine ng-untouched ng-valid ng-not-empty" onchange="fetchSelectGangRank()">' +
			'<option value="">None</option>' +
			'</select>',
		buttons: {
			changeRank: {
				text: 'Change Rank',
				btnClass: 'btn-success',
				action: function () {
					if (!charID) { // selectedMember = id
						$.alert('Please Select a Member');
						return false;
					}
					$.post('https://rpuk_gangs/alter_rank', JSON.stringify({ charID, selectedRank }), function (ret_data) {
						if (ret_data.result == true) {
							$.alert({
								title: 'Rank Changed!',
								content: ret_data.message,
								icon: 'fas fa-cannabis fa-spin',
								type: 'green',
								columnClass: 'medium',
								buttons: {
									next: function () {
										//$.post('https://rpuk_gangs/escape', JSON.stringify({}));
										lead_menu()
										lead_members = JSON.parse(ret_data.gang_members)
										active = false;
									}
								}
							});
						} else {
							$.alert({
								title: 'Something went wrong...',
								content: ret_data.message,
								icon: 'fas fa-cannabis fa-spin',
								type: 'red',
								columnClass: 'medium',
								buttons: {
									next: function () {
										$.post('https://rpuk_gangs/escape', JSON.stringify({}));
										active = false;
									}
								}
							});
						}

					});

				}
			},
			goBack: {
				text: 'Return',
				btnClass: 'btn-orange',
				action: function () {
					lead_menu_members()
				}
			},
		},

		onContentReady: function () {
			$('#gang_lead_rank_list').empty()
			$('#gang_lead_rank_list').append('<option value=""></option>')
			for (let i in lead_ranks) {
				let rank = lead_ranks[i]
				$('#gang_lead_rank_list').append('<option value="' + i + '">' + rank.label + '</option>')
			}
		}
	});
}

function lead_menu_ranks() {
	$.confirm({
		title: 'RPUK Gang Rank Properties (' + gang_name + ')',
		icon: 'fas fa-cannabis fa-spin',
		type: 'green',
		columnClass: 'medium',
		alignMiddle: true,
		closeIcon: true,
		closeIcon: function () {
			$.post('https://rpuk_gangs/escape', JSON.stringify({}));
			active = false;
		},
		content: '' +
			'<select name="cars" id="gang_lead_rankProp_list" class="form-control ng-pristine ng-untouched ng-valid ng-not-empty" onchange="fetchSelectGangPropRank()">' +
			'<option value="">None</option>' +
			'</select>',
		buttons: {
			changeLabel: {
				text: 'Change Label',
				btnClass: 'btn-success',
				action: function () {
					if (!selectedRankProp) {
						$.alert('Please Select a Rank');
						return false;
					}

					//
					$.confirm({
						title: 'Change Rank Label (Currently: ' + lead_ranks[selectedRankProp].label + ')',
						icon: 'fas fa-cannabis fa-spin',
						type: 'green',
						columnClass: 'medium',
						alignMiddle: true,
						content: '' +
							'<form action="" class="formName">' +
							'<div class="form-group">' +
							'<label>Enter an appropriate rank name.<br><strong>Ensure you read the community rules.</strong></label>' +
							'<input type="text" placeholder="Gang Label" class="new_name form-control" required />' +
							'</div>' +
							'</form>',
						buttons: {
							formSubmit: {
								text: 'Submit',
								btnClass: 'btn-success',
								action: function () {
									var new_name = this.$content.find('.new_name').val();
									if (!new_name) {
										$.alert('Provide a valid name');
										return false;
									}
									$.post('https://rpuk_gangs/alter_rank_label', JSON.stringify({ selectedRankProp, new_name }), function (ret_data) {
										if (ret_data.result == true) {
											$.alert({
												title: 'Rank Label Changed!',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'green',
												columnClass: 'medium',
												buttons: {
													next: function () {
														lead_ranks = JSON.parse(ret_data.gang_ranks)
														lead_menu_ranks()
														active = false;
													}
												}
											});
										} else {
											$.alert({
												title: 'Something went wrong...',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'red',
												columnClass: 'medium',
												buttons: {
													next: function () {
														$.post('https://rpuk_gangs/escape', JSON.stringify({}));
														active = false;
													}
												}
											});
										}
									});
								}
							},
							cancel: function () {
								lead_menu_ranks()
							},
						},
						onContentReady: function () {
							var jc = this;
							this.$content.find('form').on('submit', function (e) {
								e.preventDefault();
								jc.$$formSubmit.trigger('click');
							});
						}
					});
					//

				}
			},
			togglePermission: {
				text: 'Change Permission',
				btnClass: 'btn-success',
				action: function () {
					if (!selectedRankProp) {
						$.alert('Please Select a Rank');
						return false;
					}

					//
					$.confirm({
						title: "Change " + lead_ranks[selectedRankProp].label + "'s Permissions",
						icon: 'fas fa-cannabis fa-spin',
						type: 'green',
						columnClass: 'medium',
						alignMiddle: true,
						closeIcon: true,
						closeIcon: function () {
							$.post('https://rpuk_gangs/escape', JSON.stringify({}));
							active = false;
						},
						content: '' +
							'<select name="cars" id="gang_lead_rankPerm_list" class="form-control ng-pristine ng-untouched ng-valid ng-not-empty" onchange="fetchSelectGangRankPerm()">' +
							'<option value="">None</option>' +
							'</select>',
						buttons: {
							togglePerm: {
								text: 'Toggle Permission',
								btnClass: 'btn-success',
								action: function () {
									if (!selectedRankPerm) { // selectedMember = id
										$.alert('Please Select a Permission');
										return false;
									}
									$.post('https://rpuk_gangs/alter_rank_permission', JSON.stringify({ selectedRankProp, selectedRankPerm }), function (ret_data) {
										if (ret_data.result == true) {
											$.alert({
												title: 'Rank Permission Changed!',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'green',
												columnClass: 'medium',
												buttons: {
													next: function () {
														lead_ranks = JSON.parse(ret_data.gang_ranks)
														lead_menu_ranks()
														active = false;
													}
												}
											});
										} else {
											$.alert({
												title: 'Something went wrong...',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'red',
												columnClass: 'medium',
												buttons: {
													next: function () {
														$.post('https://rpuk_gangs/escape', JSON.stringify({}));
														active = false;
													}
												}
											});
										}
									});
								}
							},
							goBack: {
								text: 'Return',
								btnClass: 'btn-orange',
								action: function () {
									lead_menu_ranks()
								}
							},
						},

						onContentReady: function () {
							$('#gang_lead_rankPerm_list').empty()
							$('#gang_lead_rankPerm_list').append('<option value=""></option>')
							for (let i in default_perms) {
								let permission = default_perms[i]
								let hasPerm = "pink"
								for (let a in lead_ranks[selectedRankProp].permissions) {
									let inPerms = lead_ranks[selectedRankProp].permissions[a]
									if (i === inPerms) {
										hasPerm = "lightgreen"
									}
								}
								$('#gang_lead_rankPerm_list').append('<option style="background:' + hasPerm + ';color:black;" value="' + i + '">' + permission[0] + '</option>')
							}
						}
					});
					//

				}
			},
			newRank: {
				text: 'Create Rank',
				btnClass: 'btn-success',
				action: function () {
					$.confirm({
						title: 'Create Gang Rank',
						icon: 'fas fa-cannabis fa-spin',
						type: 'green',
						columnClass: 'medium',
						alignMiddle: true,
						content: '' +
							'<form action="" class="formName">' +
							'<div class="form-group">' +
							'<label>Enter an appropriate rank name.<br><strong>Ensure you read the community rules.</strong></label>' +
							'<input type="text" placeholder="Gang Label" class="new_name form-control" required />' +
							'</div>' +
							'</form>',
						buttons: {
							formSubmit: {
								text: 'Submit',
								btnClass: 'btn-success',
								action: function () {
									var new_name = this.$content.find('.new_name').val();
									if (!new_name) {
										$.alert('Provide a valid name');
										return false;
									}
									$.post('https://rpuk_gangs/create_gang_rank', JSON.stringify({ new_name }), function (ret_data) {
										if (ret_data.result == true) {
											$.alert({
												title: 'New Rank Created!',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'green',
												columnClass: 'medium',
												buttons: {
													next: function () {
														lead_ranks = JSON.parse(ret_data.gang_ranks)
														lead_menu_ranks()
														active = false;
													}
												}
											});
										} else {
											$.alert({
												title: 'Something went wrong...',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'red',
												columnClass: 'medium',
												buttons: {
													next: function () {
														$.post('https://rpuk_gangs/escape', JSON.stringify({}));
														active = false;
													}
												}
											});
										}
									});
								}
							},
							cancel: function () {
								lead_menu_ranks()
							},
						},
						onContentReady: function () {
							var jc = this;
							this.$content.find('form').on('submit', function (e) {
								e.preventDefault();
								jc.$$formSubmit.trigger('click');
							});
						}
					});
					//
				}
			},
			deleteRank: {
				text: 'Delete Rank',
				btnClass: 'btn-red',
				action: function () {
					$.confirm({
						title: 'RPUK Gang Menu',
						icon: 'fas fa-cannabis fa-spin',
						type: 'red',
						content: 'Members in this rank will be moved to the lowest available rank.<br><strong>You are about to delete the rank: ' + lead_ranks[selectedRankProp].label + '</strong><br><br><strong>Ensure you are not in active roleplay scenario.</strong>',
						columnClass: 'medium',
						alignMiddle: true,
						autoClose: 'cancel|10000',
						buttons: {
							leaveGang: {
								text: 'Delete Rank',
								btnClass: 'btn-red',
								action: function () {

									$.post('https://rpuk_gangs/delete_gang_rank', JSON.stringify({ selectedRankProp }), function (ret_data) {
										if (ret_data.result == true) {
											$.alert({
												title: 'Rank Deleted!',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'green',
												columnClass: 'medium',
												buttons: {
													next: function () {
														lead_ranks = JSON.parse(ret_data.gang_ranks)
														lead_menu_ranks()
														active = false;
													}
												}
											});
										} else {
											$.alert({
												title: 'Something went wrong...',
												content: ret_data.message,
												icon: 'fas fa-cannabis fa-spin',
												type: 'red',
												columnClass: 'medium',
												buttons: {
													next: function () {
														$.post('https://rpuk_gangs/escape', JSON.stringify({}));
														active = false;
													}
												}
											});
										}
									});
								}
							},
							cancel: function () {
								lead_menu_ranks()
							}
						}
					});


				}
			},
			goBack: {
				text: 'Return',
				btnClass: 'btn-orange',
				action: function () {
					lead_menu()
				}
			},
		},

		onContentReady: function () {
			$('#gang_lead_rankProp_list').empty()
			$('#gang_lead_rankProp_list').append('<option value=""></option>')
			for (let i in lead_ranks) {
				let rank = lead_ranks[i]
				$('#gang_lead_rankProp_list').append('<option value="' + i + '">' + rank.label + '</option>')
			}
		}
	});
}