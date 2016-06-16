$(document).ready(function() {
  $('#phone-form').submit(function(e) {
    event.preventDefault();
    var number = $(this).serialize();
    $.ajax({
      method:   'PATCH',
      url:      '/api/v1/phones',
      data:     number,
      dataType: 'JSON',
      success:  flashSuccess,
      error:    flashError
    })
  });

  function flashSuccess(data){
    $('.flash').empty();
    $('.flash').append('<div class="alert text-center alert-success">Phone number updated.</div>');
  }

  function flashError(data){
    $('.flash').empty();
    $('.flash').append('<div class="alert text-center alert-danger">Could not update phone number.</div>');
  }
});
