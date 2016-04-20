$( function() {
  $('#addUserModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget)
    var url = button.data('url')
    var elem = $(this).find("select")
    
    $.ajax({ url: url })
    .done(function( data ) {
      elem.html("")
      $.each(data, function(user) {
        var value = $(this).attr('last_name') + ', ' + $(this).attr('first_name') + ' (' + $(this).attr('email') + ')'
        elem.append('<option value=' + $(this).attr('id').$oid + '>' + value + '</option>');
      });
    })
  })
})
