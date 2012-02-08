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
  if ( $('input#UserColor').length > 0 ) {
    $('#UserColor').before('<div id="colorwheel"></div>');
    var colorwheel = Raphael.colorwheel($("#colorwheel")[0], 150);
    colorwheel.input($("#UserColor")[0]);
  };
});
