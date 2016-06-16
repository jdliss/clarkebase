$(document).ready(function(){

  $('#submitName').prop('disabled', true);

  $('#wallet-form').submit(function(e){
    event.preventDefault();
    var self = this;
    var data = $("#wallet-form").serialize();
    $("#modalSubmitButton").html("<div class='sk-spinner sk-spinner-pulse'></div>")
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
      swal("Get Spending", "Wallet Created", "success")
      $("#modalSubmitButton").html("<button id='createWalletButton' type='submit' class='btn btn-success'>Create</button>")
    }

    function flashError(data){
      swal("Oh No...", "Creation Failed", "error")
      $("#modalSubmitButton").html("<button id='createWalletButton' type='submit' class='btn btn-success'>Create</button>")
    }
})
