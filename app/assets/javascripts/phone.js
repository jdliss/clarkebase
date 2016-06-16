$(document).ready(function() {
  $('#phone-form').submit(function(e) {
    event.preventDefault();
    var number = $(this).serialize();
    $("#modalSubmitButton").html("<div class='sk-spinner sk-spinner-pulse'></div>")
    $.ajax({
      method:   'PATCH',
      url:      '/api/v1/phones',
      data:     number,
      dataType: 'JSON',
      success:  flashSuccess,
      error:    flashError
    })
  });

  function flashSuccess(data){
    $('#phone-number').modal('hide')
    swal("Phone Number Updated", "You Will Now Get Updates On Transactions", "success")
    $("#modalSubmitButton").html("<button id='createWalletButton' type='submit' class='btn btn-success'>Create</button>")
  }

  function flashError(data){
    swal("Oh No...", "Creation Failed", "error")
    $("#modalSubmitButton").html("<input type='submit' value='Update' class='btn btn-success'></input></button>")

  }
});
