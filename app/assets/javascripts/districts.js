// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(function() {
	$('input#select_all').change(function(event) {
		$('input:checkbox:not(#select_all)').prop('checked', $(this).is(':checked'));
	})

	$('input:checkbox').change(function(event) {
		var form = $(this).closest('form')
		form.find("a[data-submit]").toggleClass('disabled', form.find("input:checkbox:checked").length == 0)
	})
})
