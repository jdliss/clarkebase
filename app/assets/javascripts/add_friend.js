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
    email = $('#friend-input-email').val();
    $('#friend-input-email').val("");
    $('#friend-input-key').val("");
    $.ajax({
      method:   'GET',
      url:      '/friends.js'
    });
  }

  function flashError(data){
    swal('No Friend Found!', 'No ClarkeBase User matches the submitted data.', 'error');
  }
})
