$(document).ready(function(){
  $('#add-friend').submit(function(e){
    event.preventDefault();
    var self = this;
    var value = $("#add-friend").serialize();
    $.ajax({
      method:   'PATCH',
      url:      '/api/v1/address_books',
      data:     value,
      dataType: 'JSON',
      success:  flashSuccess,
      error:    flashError
    })
  });

    function flashSuccess(data){
      $('.flash').empty();
      $('.flash').append('<div class="alert text-center alert-success">Friend added.</div>');
      $('#friend-input-email').val("");
      $('#friend-input-key').val("");
    }

    function flashError(data){
      $('.flash').empty();
      $('.flash').append('<div class="alert text-center alert-danger">Could not add friend.</div>');
    }
})
