$(document).ready(function(){

  $('#submitName').prop('disabled', true);

  $('#wallet_name').keyup(function() {
    var input = $("#wallet_name").val();
    if(input != "") {
      $('#submitName').prop('disabled', false);
    }
  });

  $('#name-wallet').submit(function(e){
    event.preventDefault();
    var self = this;
    var value = $("#name-wallet").serialize();
    $.ajax({
      method:   'POST',
      url:      '/api/v1/wallets',
      data:     value,
      dataType: 'JSON',
      success:  appendWallet(value),
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

    function appendWallet(data){
      var nameData  = data.split("=");
      var nameArray = nameData[nameData.length - 1];
      var name      = nameArray.split("+").join(" ");
      $('.wallets').append('<span class="card card-block sidebar-wallet"><a>' + name + '</a><span class="pull-right">0 CLC</span></span>');
      flashSuccess;
    }

    function flashSuccess(data){
      $('.flash').empty();
      $('.flash').append('<div class="alert text-center alert-success">Your Wallet has been created!</div>');
    }

    function flashError(data){
      $('.flash').empty();
      $('.flash').append('<div class="alert text-center alert-danger">Wallet not created, try again later.</div>');
    }
})
