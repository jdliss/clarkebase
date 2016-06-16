$(document).ready(function(){

  $('#submit-transaction').submit(function(e){
    event.preventDefault();
    var self = this;
    var value = $("#submit-transaction").serialize();
    $("#submitTransaction").html("<div class='sk-spinner sk-spinner-pulse'></div>")
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
    swal("Nice!", "Transaction Sent", "success")
    $("#submitTransaction").html("<input type='submit' id='sendCoin' class='btn btn-success btn-lg btn-block log' value='Send'></input>")
  }

  function flashError(data){
    swal("Oops...", "Something went wrong", "error");
    $("#submitTransaction").html("<input type='submit' id='sendCoin' class='btn btn-success btn-lg btn-block log' value='Send'></input>")
  }

})
