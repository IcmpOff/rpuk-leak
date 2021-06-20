$(document).ready(function(){
  // Listen for NUI Events
  window.addEventListener('message', function(event){
    // Open Skin Creator
    if(event.data.openSkinCreator == true){ //change to true to hide ingame
      $(".skinCreator").css("display","block");
	  $(".rotation").css("display","flex");
    }
    // Close Skin Creator
    if(event.data.openSkinCreator == false){
      $(".skinCreator").fadeOut(400);
	  $(".rotation").css("display","none");
    }
	// Click
    if (event.data.type == "updateMaxVal") {
	  $('input.' + event.data.classname).prop('max',event.data.maxVal);
	  $('input.' + event.data.classname).val(event.data.defaultVal);
	  $('div[name=' + event.data.classname + ']').attr('data-legend', '/'+event.data.maxVal);
	  $('div[name=' + event.data.classname + ']').text(event.data.defaultVal + '/' + event.data.maxVal);
    }
  });

  // Form update
  $('input').change(function(){
    $.post('https://rpuk_barbers/updateSkin', JSON.stringify({
      value: false,
      // Face
      dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
      mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
	  gender: $('.gender').val(),
      dadmumpercent: $('.morphologie').val(),
      skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
      eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),
      makeuptype: $('.makeuptype').val(),
      makeupthickness: $('.makeupthickness').val(),
      makeupcolor: $('input[name=makeupcolor]:checked', '#formSkinCreator').val(),
      makeupcolor2: $('input[name=makeupcolor2]:checked', '#formSkinCreator').val(),	  
	  lipsticktype: $('.lipsticktype').val(),
      lipstickthickness: $('.lipstickthickness').val(),
      lipstickcolor: $('input[name=lipstickcolor]:checked', '#formSkinCreator').val(),
      lipstickcolor2: $('input[name=lipstickcolor2]:checked', '#formSkinCreator').val(),   	    
      freckle: $('.tachesrousseur').val(),
      wrinkle: $('.rides').val(),
      wrinkleopacity: $('.rides').val(),
      hair: $('.hair').val(),
      hair2: $('.hair2').val(),  
      haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
      haircolor2: $('input[name=haircolor2]:checked', '#formSkinCreator').val(),  
      eyebrow: $('.sourcils').val(),
      eyebrowopacity: $('.epaisseursourcils').val(),
      beard: $('.barbe').val(),
      beardopacity: $('.epaisseurbarbe').val(),
      beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
      // Clothes
      hats: $('.chapeaux .active').attr('data'),
	  hats_texture: $('input[class=helmet_2]').val(),
      glasses: $('.lunettes .active').attr('data'),
	  glasses_texture: $('input[class=glasses_2]').val(),
      ears: $('.oreilles .active').attr('data'),
	  ears_texture: $('input[class=ears_2]').val(),
      tops: $('.hauts .active').attr('data'),
      pants: $('.pantalons .active').attr('data'),
      shoes: $('.chaussures .active').attr('data'),
      watches: $('.montre .active').attr('data'),
    }));
  });
  $('.arrow').on('click', function(e){
    e.preventDefault();
    $.post('https://rpuk_barbers/updateSkin', JSON.stringify({
      value: false,
      // Face
      dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
      mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
	  gender: $('.gender').val(),
      dadmumpercent: $('.morphologie').val(),
      skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
      eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),  
      makeuptype: $('.makeuptype').val(),
      makeupthickness: $('.makeupthickness').val(),
      makeupcolor: $('input[name=makeupcolor]:checked', '#formSkinCreator').val(),
      makeupcolor2: $('input[name=makeupcolor2]:checked', '#formSkinCreator').val(),    
	  lipsticktype: $('.lipsticktype').val(),
      lipstickthickness: $('.lipstickthickness').val(),
      lipstickcolor: $('input[name=lipstickcolor]:checked', '#formSkinCreator').val(),
      lipstickcolor2: $('input[name=lipstickcolor2]:checked', '#formSkinCreator').val(),   
	  freckle: $('.tachesrousseur').val(),
      wrinkle: $('.rides').val(),
      wrinkleopacity: $('.rides').val(),
      hair: $('.hair').val(),
	  hair2: $('.hair2').val(),
      haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
      haircolor2: $('input[name=haircolor2]:checked', '#formSkinCreator').val(),
      eyebrow: $('.sourcils').val(),
      eyebrowopacity: $('.epaisseursourcils').val(),
      beard: $('.barbe').val(),
      beardopacity: $('.epaisseurbarbe').val(),
      beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
      // Clothes
      hats: $('.chapeaux .active').attr('data'),
	  hats_texture: $('input[class=helmet_2]').val(),
      glasses: $('.lunettes .active').attr('data'),
	  glasses_texture: $('input[class=glasses_2]').val(),
      ears: $('.oreilles .active').attr('data'),
	  ears_texture: $('input[class=ears_2]').val(),
      tops: $('.hauts .active').attr('data'),
      pants: $('.pantalons .active').attr('data'),
      shoes: $('.chaussures .active').attr('data'),
      watches: $('.montre .active').attr('data'),
    }));
  });

  // Form submited
  $('.yes').on('click', function(e){
    e.preventDefault();
    $.post('https://rpuk_barbers/updateSkin', JSON.stringify({
      value: true,
      // Face
      dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
      mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
	  gender: $('.gender').val(),
      dadmumpercent: $('.morphologie').val(),
      skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
      eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),
      makeuptype: $('.makeuptype').val(),
      makeupthickness: $('.makeupthickness').val(),
      makeupcolor: $('input[name=makeupcolor]:checked', '#formSkinCreator').val(),
      makeupcolor2: $('input[name=makeupcolor2]:checked', '#formSkinCreator').val(),
	  lipsticktype: $('.lipsticktype').val(),
      lipstickthickness: $('.lipstickthickness').val(),
      lipstickcolor: $('input[name=lipstickcolor]:checked', '#formSkinCreator').val(),
      lipstickcolor2: $('input[name=lipstickcolor2]:checked', '#formSkinCreator').val(),       
	  freckle: $('.tachesrousseur').val(),
      wrinkle: $('.rides').val(),
      wrinkleopacity: $('.rides').val(),
      hair: $('.hair').val(),
      hair2: $('.hair2').val(),
      haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
      haircolor2: $('input[name=haircolor2]:checked', '#formSkinCreator').val(),	  
      eyebrow: $('.sourcils').val(),
      eyebrowopacity: $('.epaisseursourcils').val(),
      beard: $('.barbe').val(),
      beardopacity: $('.epaisseurbarbe').val(),
      beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
      // Clothes
      hats: $('.chapeaux .active').attr('data'),
	  hats_texture: $('input[class=helmet_2]').val(),
      glasses: $('.lunettes .active').attr('data'),
	  glasses_texture: $('input[class=glasses_2]').val(),
      ears: $('.oreilles .active').attr('data'),
	  ears_texture: $('input[class=ears_2]').val(),
      tops: $('.hauts .active').attr('data'),
      pants: $('.pantalons .active').attr('data'),
      shoes: $('.chaussures .active').attr('data'),
      watches: $('.montre .active').attr('data'),
    }));
  }); 
  // Rotate player
  $(document).keypress(function(e) {
    if(e.which == 97){ // A pressed
      $.post('https://rpuk_barbers/rotaterightheading', JSON.stringify({
        value: 10
      }));
    }
    if(e.which == 100){ // D pressed
      $.post('https://rpuk_barbers/rotateleftheading', JSON.stringify({
        value: 10
      }));
    }
	
    if(e.which == 120){ // ESC pressed
	  $.post('https://rpuk_barbers/closeall', JSON.stringify({
        value: 10
      }));	  
    }

	
  });

  // Zoom out camera for clothes
  $('#tabs label').on('click', function(e){
    //e.preventDefault();
    $.post('https://rpuk_barbers/zoom', JSON.stringify({
      zoom: $(this).attr('data-link')
    }));
  });
});
