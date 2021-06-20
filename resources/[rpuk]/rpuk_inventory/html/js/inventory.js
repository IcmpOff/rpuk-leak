var type = "normal";
var typeOfInv = "normal";
var overrideImage = {};
var otherItems;

$(function () {
	$("#close").click(() => {
		$.post("https://rpuk_inventory/NUIFocusOff");
	});

	$("#dialog").dialog({ autoOpen: false, clickOutside: true });

	$.contextMenu({
		selector: '.context-menu-one',
		build: function ($trigger, e) {

			return {
				callback: function (key, options, a) {
					var itemName = $(e.target).data('item');

					if (itemName) {
						if (key == 'use') {
							$.post("https://rpuk_inventory/UseItem", JSON.stringify({ item: itemName }));
						} else if (key == 'throw') {
							$.post("https://rpuk_inventory/DropItem", JSON.stringify({
								item: itemName,
								number: parseInt($("#count").val())
							}));
						} else {
							$.post("https://rpuk_inventory/GiveItem", JSON.stringify({
								player: parseInt(key),
								item: itemName,
								number: parseInt($("#count").val())
							}));
						}
					}
				},
				items: {
					"use": { name: "Use", icon: "fa-mouse-pointer" },
					"give": { name: "Give", icon: "copy", items: asyncGetNearbyPlayers() },
					"throw": { name: "Throw", icon: "fa-trash" },
				}
			};
		}
	});
});

var asyncGetNearbyPlayers = function () {
	var deferred = jQuery.Deferred();

/*
	setTimeout(function () {
		var persons = [
			{ playerId: 1, name: 'Stranger 1', icon: 'fa-user' },
			{ playerId: 2, name: 'Stranger 2', icon: 'fa-user' },
			{ playerId: 3, name: 'Stranger 3', icon: 'fa-user' },
		]
		deferred.resolve(persons);
	}, 2000);
*/
	$.post('https://rpuk_inventory/getNearbyPlayers', '', function (nearbyPlayers) {
		deferred.resolve(nearbyPlayers);
	});

	return deferred.promise();
};

window.addEventListener("message", function (event) {
	if (event.data.action == "display") {
		type = event.data.type;

		$(".info-div").show();
		$("#otherInventory").show();
		$(".ui").show();
	} else if (event.data.action == "updateType") {
		typeOfInv = event.data.typeOfInv;
	} else if (event.data.action == "hide") {
		typeOfInv = "normal";
		$("#dialog").dialog("close");
		$(".ui").hide();
		$(".item").remove();
		$("#otherInventory").html("<div id=\"noSecondInventoryMessage\"></div>");
		$("#noSecondInventoryMessage").html('');
		$(".info-div").html('');
	} else if (event.data.action == "setItems") {
		inventorySetup(event.data.itemList);
		$(".info-div2").html(event.data.text);
	} else if (event.data.action == "setSecondInventoryItems") {
		otherItems = event.data.itemList;
		secondInventorySetup(event.data.itemList);
	} else if (event.data.action == "setInfoText") {
		$(".info-div").html(event.data.text);
	}
});

function closeInventory() {
	$.post("https://rpuk_inventory/NUIFocusOff");
}

function getImageName(itemName) {
	if (overrideImage[itemName]) {
		return overrideImage[itemName];
	} else {
		return itemName;
	}
}

function inventorySetup(items) {
	$("#playerInventory").html("");
	var lastSlot = 0;

	$.each(items, function (index, item) {
		var count = setCount(item);

		$("#playerInventory").append(
			`<div class="slot context-menu-one">
				<div id="item-${index}" class="item" style = "background-image: url('img/items/${getImageName(item.name)}.png')">
					<div class="item-count">${count}</div>
					<div class="item-name">${item.label}</div>
				</div>
				<div class="item-name-bg"></div>
			</div>`);
		$('#item-' + index).data('item', item);
		$('#item-' + index).data('inventory', "main");
		lastSlot = lastSlot + 1;
	});

	for (var i = 1; i < (49 - lastSlot); i++) {
		$("#playerInventory").append(`
		<div class="slot">
			<div id="item-${i}" class="item">
				<div class="item-count"></div>
				<div class="item-name"></div>
			</div>
			<div class="item-name-bg"></div>
		</div>`);
	}

	$('.item').draggable({
		helper: 'clone',
		appendTo: 'body',
		zIndex: 99999,
		revert: 'invalid',
		start: function (event, ui) {
			var itemData = $(this).data("item");

			if (itemData) {
				if (itemData.count == 1 || itemData.count == parseInt($("#count").val())) {
					$(this).css('background-image', 'none');
				}

				if (!itemData.canRemove) {
					$("#drop").addClass("disabled");
					$("#give").addClass("disabled");
				}

				if (!itemData.usable) {
					$("#use").addClass("disabled");
				}
			}
		},
		stop: function () {
			var itemData = $(this).data("item");

			if (itemData) {
				$(this).css('background-image', 'url(\'img/items/' + itemData.name + '.png\'');
				$("#drop").removeClass("disabled");
				$("#use").removeClass("disabled");
				$("#give").removeClass("disabled");
			}
		}
	});
}

function secondInventorySetup(items) {
	$("#otherInventory").html("");
	var lastSlot = 0;

	$.each(items, function (index, item) {
		var count;

		if (typeOfInv == "normal") {
			count = setCount(item);
		} else if (typeOfInv == "store") {
			count = setCountStore(item);
		}

		$("#otherInventory").append(`
			<div class="slot">
				<div id="itemOther-${index}" class="item itemOther" style="background-image: url('img/items/${getImageName(item.name)}.png')">
					<div class="item-count">${count}</div>
					<div class="item-name">${item.label}</div>
				</div>
				<div class="item-name-bg"></div>
			</div>`);
		$('#itemOther-' + index).data('item', item);
		$('#itemOther-' + index).data('inventory', "second");
		lastSlot = lastSlot + 1;
	});

	for (var i = 1; i < (49 - lastSlot); i++) {
		$("#otherInventory").append(`
		<div class="slot">
			<div id="item-${i}" class="item">
				<div class="item-count"></div>
				<div class="item-name"></div>
			</div>

			<div class="item-name-bg"></div>
		</div>`);
	}
}

function setCountStore(item) {
	var count = '£<span class="item-count-box">' + item.count.toLocaleString() + '</span>';

	if (item.type === "item_weapon") {
		count = '£<span class="item-count-box">' + item.count.toLocaleString() + '</span>';
	}

	if (item.type === "item_account") {
		if (item.name === "black_money") {
			count = '£<span class="item-count-box5">' + item.count.toLocaleString() + '</span>';
		} else {
			count = '£<span class="item-count-box3">' + item.count.toLocaleString() + '</span>';
		}
	}
	return count;
}

function updatePrices(amount) {
	$.each(otherItems, function (index, item) {
		$("#itemOther-" + index + " .item-count").html("£" + ($("#itemOther-" + index).data("item").count * amount).toLocaleString());
	})
}

function setCount(item) {
	var count = '<span class="item-count-box">' + item.count + '</span>';

	if (item.type === "item_weapon") {
		count = '<span class="item-count-box">' + item.count + '</span>';
	}

	if (item.type === "item_account") {
		if (item.name === "black_money") {
			count = '<span class="item-count-box5">' + item.count.toLocaleString() + '</span>';
		} else {
			count = '<span class="item-count-box3">' + item.count.toLocaleString() + '</span>';
		}
	}

	return count;
}

$(document).ready(function () {
	$(document).on('click', '.item', function (event) {
		if (event.shiftKey) {
			var itemData = $(this).data("item");
			var itemInventory = $(this).data("inventory");

			if (itemInventory === 'main') {
				inventoryPut(itemData);
			} else if (itemInventory === "second") {
				inventoryTake(itemData);
			}
		}
	});

	$(document).on('dblclick', '.item', function () {
		var itemData = $(this).data('item');
		if (itemData.usable) {
			$.post("https://rpuk_inventory/UseItem", JSON.stringify({ item: itemData }));
		}
	});

	$("#count").focus(function () {
		$(this).val("");
	}).blur(function () {
		if ($(this).val() == "") {
			$(this).val("1");
		}

		if (typeOfInv == "store") {
			updatePrices($(this).val());
		}
	});

	document.onkeydown = function (event) {
		if (event.key == 'F3' || event.key == 'Escape') {
			closeInventory();
		}
	};

	$('#use').droppable({
		hoverClass: 'hoverControl',
		drop: function (event, ui) {
			var itemData = ui.draggable.data("item");
			if (itemData && itemData.usable) {
				$.post("https://rpuk_inventory/UseItem", JSON.stringify({ item: itemData }));
			}
		}
	});

	$('#give').droppable({
		hoverClass: 'hoverControl',
		drop: function (event, ui) {
			var itemData = ui.draggable.data("item");
			if (itemData && itemData.canRemove) {
				$.post('https://rpuk_inventory/getNearbyPlayers', '', function (nearbyPlayers) {
					$("#nearPlayers").html("");

					$.each(nearbyPlayers, function (k, v) {
						$("#nearPlayers").append(`<button class="nearbyPlayerButton" data-playerid="${v.playerId}">${v.name}</button>`);
					});

					$("#dialog").dialog("open");

					$(".nearbyPlayerButton").click(function ($trigger) {
						var playerId = $(this).data('playerid');
						$("#dialog").dialog("close");

						$.post("https://rpuk_inventory/GiveItem", JSON.stringify({
							player: playerId,
							item: itemData,
							number: parseInt($("#count").val())
						}));
					});
				});
			}
		}
	});

	$('#drop').droppable({
		hoverClass: 'hoverControl',
		drop: function (event, ui) {
			var itemData = ui.draggable.data("item");

			if (itemData && itemData.canRemove) {
				$.post("https://rpuk_inventory/DropItem", JSON.stringify({
					item: itemData,
					number: parseInt($("#count").val())
				}));
			}
		}
	});

	$('#playerInventory').droppable({
		drop: function (event, ui) {
			var itemData = ui.draggable.data("item");
			var itemInventory = ui.draggable.data("inventory");

			if (itemInventory === "second") {
				inventoryTake(itemData);
			}
		}
	});

	$('#otherInventory').droppable({
		drop: function (event, ui) {
			var itemData = ui.draggable.data("item");
			var itemInventory = ui.draggable.data("inventory");

			if (itemInventory === "main") {
				inventoryPut(itemData);
			}
		}
	});

	$("#count").on("keypress keyup blur", function (event) {
		$(this).val($(this).val().replace(/[^\d].+/, ""));
		if ((event.which >= 48 && event.which <= 57) || (event.which <= 105 && event.which >= 96) || event.which == 8) {
			if (typeOfInv == "store") {
				updatePrices($(this).val());
			}
		} else {
			event.preventDefault();
		}
	});

	const inventoryPut = (data) => {
		$.post("https://rpuk_inventory/PutIntoSecond", JSON.stringify({
			item: data,
			number: parseInt($("#count").val()),
			type: type
		}));
	};

	const inventoryTake = (data) => {
		$.post("https://rpuk_inventory/TakeFromSecond", JSON.stringify({
			item: data,
			number: parseInt($("#count").val()),
			type: type
		}));
	};


/*
	$(".info-div").show();
	$("#otherInventory").show();
	$(".ui").fadeIn();

	var persons = [
		{ name: "bread", label: 'Bread', count: 1 },
		{ name: "water", label: 'Water', count: 1 },
		{ name: "cannabis", label: 'Cannabis', count: 1, usable: true },
		{ name: "bread", label: 'Bread', count: 1 },
		{ name: "water", label: 'Water', count: 1 },
		{ name: "cannabis", label: 'Cannabis', count: 1, usable: true }
	]

	inventorySetup(persons);
*/

});