$(document).ready(function(){

  $('#submitName').prop('disabled', true);

  $('#wallet-form').submit(function(e){
    event.preventDefault();
    var self = this;
    var data = $("#wallet-form").serialize();
    $.ajax({
      method:   'POST',
      url:      '/api/v1/wallets',
      data:     data,
      dataType: 'JSON',
      success:  appendWallet,
      error:    flashError
    })
  });

    function appendWallet(data){
      $.ajax({
        method:   'GET',
        url:      '/dashboard.js',
        success:  flashSuccess,
        error:    flashError
      });
    }

    function flashSuccess(data){
      $('#dash-create-wallet').modal('hide')
      $('.flash').empty();
      $('.flash').append('<div class="alert text-center alert-success">Your Wallet has been created!</div>');
    }

    function flashError(data){
      $('#dash-create-wallet').modal('hide')
      $('.flash').empty();
      $('.flash').append('<div class="alert text-center alert-danger">Wallet not created, try again later.</div>');
    }
})
