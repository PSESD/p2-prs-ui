// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require_tree .

$( function() {
  $('[data-toggle="tooltip"]').tooltip()
  
  $('[data-toggle="html-popover"]').popover({
    html: true,
    content: function() {
      var content = $(this).attr("data-source")
      return $(content).children("section").html()
    },
    title: function() {
      var title = $(this).attr("data-source")
      return $(title).children("summary").html()
    }
  })
  
  $('#filtersModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget)
    var url = button.data('url')
    var elem = $(this).find("pre")
    elem.html("<i class='glyphicon glyphicon-refresh spinning' /> Loading...")

    $.ajax({ url: url })
    .done(function( html ) {
      elem.html( html )
    })
  })
  
  $('.input-daterange').datepicker({
      format: "yyyy-mm-dd",
      todayBtn: "linked",
      todayHighlight: true,
      disableTouchKeyboard: true,
      autoclose: true
  });
  
  $("a[data-submit]").on('click', function(event) {
	  event.preventDefault();
	  $( this ).closest('form').submit();
  })
  
})
