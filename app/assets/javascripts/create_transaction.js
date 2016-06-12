$(document).ready(function(){

  $('#submit-transaction').submit(function(e){
    event.preventDefault();
    var self = this;
    var value = $("#submit-transaction").serialize();
    $.ajax({
      method:   'POST',
      url:      '/api/v1/transactions',
      data:     value,
      dataType: 'JSON',
      success:  flashSuccess,
      error:    flashError
    })
  });


  function flashSuccess(data){
    $('.flash').empty();
    $('.flash').append('<div class="alert text-center alert-success">Transaction Sent!</div>');
  }

  function flashError(data){
    $('.flash').empty();
    $('.flash').append('<div class="alert text-center alert-danger">Transaction not made, try again.</div>');
  }

})
