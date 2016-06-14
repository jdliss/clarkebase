$(document).ready(function(){

  $('#submitName').prop('disabled', true);

  $('#wallet_name').keyup(function() {
    var input = $("#wallet_name").val();
    if(input != "") {
      $('#submitName').prop('disabled', false);
    }
  });

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
        success:  flashSuccess
      });
    }

    function flashSuccess(data){
      $('.flash').empty();
      $('.flash').append('<div class="alert text-center alert-success">Your Wallet has been created!</div>');
    }

    function flashError(data){
      $('.flash').empty();
      $('.flash').append('<div class="alert text-center alert-danger">Wallet not created, try again later.</div>');
    }

    // parameterize = function (string) {
    //   return string.trim().toLowerCase().replace(/[^a-zA-Z0-9 -]/, "").replace(/\s/g, "-");
    // };
    //
    // nameFormatter = function (string) {
    //   var nameData  = string.split("=");
    //   var nameArray = nameData[nameData.length - 1];
    //   var name      = nameArray.split("+").join(" ");
    //   return name;
    // }
})
