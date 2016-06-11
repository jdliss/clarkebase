$(document).ready(function(){
  $('#create-wallet').on('click', function(){
    var self = this;
    $.ajax({
      method:   'POST',
      url:      '/api/v1/wallets',
      dataType: 'JSON',
      success:  flashSuccess,
      error:    flashError
    })
  });

  $('#submit-key').submit(function(e){
    event.preventDefault();
    var self = this;
    var value = $("#submit-key").serialize();
    $.ajax({
      method:   'POST',
      url:      '/api/v1/wallets',
      data:     value,
      dataType: 'JSON',
      success:  flashSuccess,
      error:    flashError
    })
  });

    function flashSuccess(data){
      $('.flash').empty();
      $('.flash').append('<div class="alert text-center alert-success">Your Wallet has been created!</div>');
      $(".new-wallet").html('<a href="/dashboard" class="btn btn-success btn-lg btn-block dash-button">Take Me to My Dashboard</button>');
      // reload side_nav
    }

    function flashError(data){
      $('.flash').empty();
      $('.flash').append('<div class="alert text-center alert-danger">Wallet not created, try again.</div>');
    }
})
