//
// TX.UserColor.js
// belongs to Module CssUserColors.pm
//
// prerequesites:
//  jquery
//  colorwheel.js ( which needs raphael and jquery )
//
// functions:
// - loads css with user colors
// - augments admin user color input with colorwheel
//


$(document).ready(function() {
  $('head').append('<link rel="stylesheet" type="text/css" href="'+ window.location.pathname +'?Action=UserColorCss" />');
  //Test for html5 input type color support
  var i = document.createElement("input");
  i.setAttribute("type","color");
  var input_color_support = (i.type === "color");
  if ( $('input#UserColor').length > 0 ) {
    if (input_color_support) {
      $('input#UserColor')[0].setAttribute('type','color');
    } else {
      $('#UserColor').before('<div id="colorwheel"></div>');
      var colorwheel = Raphael.colorwheel($("#colorwheel")[0], 150);
      colorwheel.input($("#UserColor")[0]);
    };
  };
});
