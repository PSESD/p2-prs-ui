var domain = function() {
  $('#authorized_entity_mainContact_webAddress').parent().attr('class', 'col-sm-3');
  $('#authorized_entity_mainContact_webAddress').parent().parent().append('<div class="col-sm-3 form-control-static">.studentsuccesslink.org</div>');
}

$(document).ready(function() {
  domain();
});
