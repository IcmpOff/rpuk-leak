$(document).ready(function () {
	$(".rotation").fadeOut(0);

	window.addEventListener('message', function (event) {
		if (event.data.openSkinCreator) {
			if (event.data.state) {
				$(".skinCreator").fadeIn(400);
				$(".rotation").fadeIn(400);
			} else {
				$(".skinCreator").fadeOut(400);
				$(".rotation").fadeOut(400);
			}
		} else if (event.data.addItems) {
			$(".hair").prop('max', event.data.numOfHairs);
			$(".hair").parent().parent().find('.label-value').attr({"data-legend": "/"+event.data.numOfHairs});
			$(".hair").parent().parent().find('.label-value').text("0/"+event.data.numOfHairs);

			// clothes
			var hatMax = 0;
			var glassesMax = 0;
			var earsMax = 0;
			var topMax = 0;
			var pantsMax = 0;
			var shoesMax = 0;
			var watchesMax = 0;

			jQuery.each(event.data.hats, function(index, label) {
				hatMax = hatMax + 1;
				$(".chapeaux li:last").after(`<li data="${index+1}">${label}</li>`);
			});

			jQuery.each(event.data.glasses, function(index, label) {
				glassesMax = glassesMax + 1;
				$(".lunettes li:last").after(`<li data="${index+1}">${label}</li>`);
			});

			jQuery.each(event.data.ears, function(index, label) {
				earsMax = earsMax + 1;
				$(".oreilles li:last").after(`<li data="${index+1}">${label}</li>`);
			});

			jQuery.each(event.data.tops, function(index, label) {
				topMax = topMax + 1;
				$(".hauts li:last").after(`<li data="${index+1}">${label}</li>`);
			});

			jQuery.each(event.data.pants, function(index, label) {
				pantsMax = pantsMax + 1;
				$(".pantalons li:last").after(`<li data="${index+1}">${label}</li>`);
			});

			jQuery.each(event.data.shoes, function(index, label) {
				shoesMax = shoesMax + 1;
				$(".chaussures li:last").after(`<li data="${index+1}">${label}</li>`);
			});

			jQuery.each(event.data.watches, function(index, label) {
				watchesMax = watchesMax + 1;
				$(".montre li:last").after(`<li data="${index+1}">${label}</li>`);
			});

			$(".chapeaux").parent().find('.label-value').text('0/'+hatMax);
			$(".lunettes").parent().find('.label-value').text('0/'+glassesMax);
			$(".oreilles").parent().find('.label-value').text('0/'+earsMax);
			$(".hauts").parent().find('.label-value').text('0/'+topMax);
			$(".pantalons").parent().find('.label-value').text('0/'+pantsMax);
			$(".chaussures").parent().find('.label-value').text('0/'+shoesMax);
			$(".montre").parent().find('.label-value').text('0/'+watchesMax);
		} else if (event.data.receivePlayerModels) {
			$('#playermodel').empty();
	
			jQuery.each(event.data.availableModels, function(model, label) {
				$('#playermodel').append(new Option(label, model));
			});

			var firstModel = $('#playermodel option:nth-child(1)').val();

			$.post('http://esx_skincreation/onSelectModel', JSON.stringify({
				model: firstModel
			}));

			updateSkin();
		}
	});

	$('.gender').change(function () {
		$.post('http://esx_skincreation/onSelectGender', JSON.stringify({
			gender: $(this).val()
		}));
	});

	$('#playermodel').change(function () {
		$.post('http://esx_skincreation/onSelectModel', JSON.stringify({
			model: $(this).val()
		}));
	});

	// Form update
	$('input').change(function () {
		updateSkin();
	});

	$('.arrow').on('click', function (e) {
		e.preventDefault();
		$.post('http://esx_skincreation/updateSkin', JSON.stringify({
			value: false,
			model: $('#playermodel').find(':selected').val(),

			// Face
			dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
			mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
			dadmumpercent: $('.morphologie').val(),
			skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
			eyecolor: $('input[name=eyecolor]:checked', '#formSkinCreator').val(),
			acne: $('.acne').val(),
			skinproblem: $('.pbpeau').val(),
			freckle: $('.tachesrousseur').val(),
			wrinkle: $('.rides').val(),
			wrinkleopacity: $('.rides').val(),
			hair: $('.hair').val(),
			haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
			eyebrow: $('.sourcils').val(),
			eyebrowopacity: $('.epaisseursourcils').val(),
			beard: $('.barbe').val(),
			beardopacity: $('.epaisseurbarbe').val(),
			beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),

			// Clothes
			hats: $('.chapeaux .active').attr('data'),
			glasses: $('.lunettes .active').attr('data'),
			ears: $('.oreilles .active').attr('data'),
			tops: $('.hauts .active').attr('data'),
			pants: $('.pantalons .active').attr('data'),
			shoes: $('.chaussures .active').attr('data'),
			watches: $('.montre .active').attr('data'),
		}));
	});

	// Form submited
	$('.yes').on('click', function (e) {
		e.preventDefault();
		$.post('http://esx_skincreation/updateSkin', JSON.stringify({
			value: true,

			// Face
			dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
			mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
			dadmumpercent: $('.morphologie').val(),
			skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
			eyecolor: $('input[name=eyecolor]:checked', '#formSkinCreator').val(),
			acne: $('.acne').val(),
			skinproblem: $('.pbpeau').val(),
			freckle: $('.tachesrousseur').val(),
			wrinkle: $('.rides').val(),
			wrinkleopacity: $('.rides').val(),
			hair: $('.hair').val(),
			haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
			eyebrow: $('.sourcils').val(),
			eyebrowopacity: $('.epaisseursourcils').val(),
			beard: $('.barbe').val(),
			beardopacity: $('.epaisseurbarbe').val(),
			beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),

			// Clothes
			hats: $('.chapeaux .active').attr('data'),
			glasses: $('.lunettes .active').attr('data'),
			ears: $('.oreilles .active').attr('data'),
			tops: $('.hauts .active').attr('data'),
			pants: $('.pantalons .active').attr('data'),
			shoes: $('.chaussures .active').attr('data'),
			watches: $('.montre .active').attr('data'),
		}));
	});
	// Rotate player
	$(document).keypress(function (e) {
		if (e.which == 97) { // A pressed
			$.post('http://esx_skincreation/rotaterightheading', JSON.stringify({
				value: 10
			}));
		}
		if (e.which == 101) { // E pressed
			$.post('http://esx_skincreation/rotateleftheading', JSON.stringify({
				value: 10
			}));
		}
	});

	// Zoom out camera for clothes
	$('.tab a').on('click', function (e) {
		e.preventDefault();
		$.post('http://esx_skincreation/zoom', JSON.stringify({
			zoom: $(this).attr('data-link')
		}));
	});

	function updateSkin() {
		$.post('http://esx_skincreation/updateSkin', JSON.stringify({
			value: false,

			// Face
			dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
			mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
			dadmumpercent: $('.morphologie').val(),
			skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
			eyecolor: $('input[name=eyecolor]:checked', '#formSkinCreator').val(),
			acne: $('.acne').val(),
			skinproblem: $('.pbpeau').val(),
			freckle: $('.tachesrousseur').val(),
			wrinkle: $('.rides').val(),
			wrinkleopacity: $('.rides').val(),
			hair: $('.hair').val(),
			haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
			eyebrow: $('.sourcils').val(),
			eyebrowopacity: $('.epaisseursourcils').val(),
			beard: $('.barbe').val(),
			beardopacity: $('.epaisseurbarbe').val(),
			beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),

			// Clothes
			hats: $('.chapeaux .active').attr('data'),
			glasses: $('.lunettes .active').attr('data'),
			ears: $('.oreilles .active').attr('data'),
			tops: $('.hauts .active').attr('data'),
			pants: $('.pantalons .active').attr('data'),
			shoes: $('.chaussures .active').attr('data'),
			watches: $('.montre .active').attr('data'),
		}));
	}
});
