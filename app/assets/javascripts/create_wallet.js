$(document).ready(function(){
  $('#create-wallet').on('click', function(){
    var self = this;
    $.ajax({
      method:   'POST',
      url:      '/api/v1/wallets',
      dataType: 'JSON',
      success: function(data){
        $('.flash').empty();
        $('.flash').append('<div class="alert text-center alert-success">Your Wallet has been created!</div>');
        $(".new-wallet").html('<a href="/dashboard" class="btn btn-success btn-lg btn-block dash-button">Take Me to My Dashboard</button>');
      },
      error: function(data){
        $('.flash').empty();
        $('.flash').append('<div class="alert text-center alert-danger">Wallet not created, try again.</div>');
      }
    });
  })
})
