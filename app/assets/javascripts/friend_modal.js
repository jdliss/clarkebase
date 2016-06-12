$(document).ready(function() {
  $('.toggle-modal').on('click', function() {
    event.preventDefault();
    var email = $(this).attr("data-email");
    var address = $(this).attr("data-address");

    $("#myModalLabel").empty();
    $("#myModalLabel").append(email + "'s ClarkeCoin Address")
    $("#addy").val("");
    $("#addy").val(address);
    $("#address-modal").modal('show');
  });
});
