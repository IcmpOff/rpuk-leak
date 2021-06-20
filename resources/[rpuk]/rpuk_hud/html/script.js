window.addEventListener('message', function (event) {
	switch (event.data.action) {
		case 'setStatusValue':
			if (event.data.name == 'hunger') {
				$("#boxSetHunger").css("width", event.data.value + "%");
			} else if (event.data.name == 'thirst') {
				$("#boxSetThirst").css("width", event.data.value + "%");
			}

			break;

		case 'updateStatusHud':
			$("body").css("display", event.data.show ? "block" : "none");
			$("#boxSetHealth").css("width", event.data.health + "%");
			$("#boxSetArmour").css("width", event.data.armour + "%");
			$("#boxSetOxygen").css("width", event.data.oxygenLevel + "%");
			$("#statusHud").css("width", (event.data.bwidth * screen.width) + "px");
			$("#statusHud").css("left", (event.data.leftx * screen.width) + "px");
			$(".hudCar").css("left", ((event.data.rightx + 0.03) * screen.width) + "px");
			$("#container").css("left", ((event.data.rightx + 0.06) * screen.width) + "px");
			$("#dirBar").css("left", ((event.data.rightx + 0.01) * screen.width) + "px");
			$("#statushud").css("height", (event.data.height * 100) + "%");
			break;

		case 'locationHud':
			if (event.data.locationToggle == true) {
				$("#uicompass").css("rotate", event.data.rotate + "deg");
				$("#dirBar").css("display", event.data.locationToggle ? "block" : "none");
				$("#location").text(event.data.Message);
				$(".cdirBar").css('display', 'inline-block');
				$(".hudCar").css('display', 'inline-block');
			} else {
				$(".cdirBar").css('display', 'none');
				$(".hudCar").css('display', 'none');
			}

			break;

		case "car":
			if (event.data.showcarhud == true) {
				$(".addon").css('display', 'inline-block');
				$(".counter").css('display', 'inline-block');
				setProgressSpeed(Math.round(event.data.speed), ".progress-speed");
				setProgressFuel(event.data.fuel, ".progress-fuel");
				if (event.data.fuel < 25) {
					$("#fuel").attr("href", "img/fuel2.png");
				} else {
					$("#fuel").attr("href", "img/fuel.png");
				}
				$(".mph").text(event.data.speedType);
			} else {
				$(".addon").css('display', 'none');
				$(".counter").css('display', 'none');
			}

			break;

		case "seatbelt":
			$("#container").stop(false, true);
			if (event.data.showSeatbelt == false) {
				$("#container").css('display', 'inline-block');
				$("#container").animate({
					opacity: "1.0"
				},
					700, function () {
					});

			} else {
				$("#container").fadeOut();
			}

			break;
	}
});

function widthHeightSplit(value, ele) {
	let height = 25.5;
	let eleHeight = (value / 100) * height;
	let leftOverHeight = height - eleHeight;

	ele.css("height", eleHeight + "px");
	ele.css("top", leftOverHeight + "px");
};

function Progress(percent, element) {
	var circle = document.querySelector(element);
	var radius = circle.r.baseVal.value;
	var circumference = radius * 2 * Math.PI;
	var html = $(element).parent().parent().find("span");

	circle.style.strokeDasharray = `${circumference} ${circumference}`;
	circle.style.strokeDashoffset = `${circumference}`;

	const offset = circumference - ((-percent * 100) / 100 / 100) * circumference;
	circle.style.strokeDashoffset = -offset;

	html.text(Math.round(percent));
}

function setProgressSpeed(value, element) {
	var circle = document.querySelector(element);
	var radius = circle.r.baseVal.value;
	var circumference = radius * 2 * Math.PI;
	var html = $(element).parent().parent().find("span");
	var percent = (value * 100) / 220;

	circle.style.strokeDasharray = `${circumference} ${circumference}`;
	circle.style.strokeDashoffset = `${circumference}`;

	const offset = circumference - ((-percent * 73) / 100 / 100) * circumference;
	circle.style.strokeDashoffset = -offset;

	// var speed = Math.floor(value * 1.8);
	// if (speed == 81 || speed == 131) {
	// 	speed = speed - 1;
	// }

	html.text(value);
}

function setProgressFuel(percent, element) {
	var circle = document.querySelector(element);
	var radius = circle.r.baseVal.value;
	var circumference = radius * 2 * Math.PI;
	var html = $(element).parent().parent().find("span");

	circle.style.strokeDasharray = `${circumference} ${circumference}`;
	circle.style.strokeDashoffset = `${circumference}`;

	const offset = circumference - ((-percent * 73) / 100 / 100) * circumference;
	circle.style.strokeDashoffset = -offset;

	html.text(Math.round(percent));
}