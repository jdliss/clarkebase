$(document).ready(function(){
  $('#create-wallet').on('click', function(){
    var self = this;
    $.ajax({
      method:   'POST',
      url:      '/api/v1/wallets',
      dataType: 'JSON',
      success: function(data){
        $(self).parent().hide();
        $('.flash').empty();
        $('.flash').append('<div class="alert alert-success">Your Wallet has been created!</div>');
      },
      error: function(data){
        $('.flash').empty();
        $('.flash').append('<div class="alert alert-danger">Wallet not created, try again.</div>');
      }
    });
  })
})
