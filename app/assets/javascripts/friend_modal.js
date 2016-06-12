$(document).ready(function() {
  $('.toggle-address-modal').on('click', function() {
    event.preventDefault();
    var email = $(this).attr("data-email");
    var address = $(this).attr("data-address");

    $("#addressModalLabel").empty();
    $("#addressModalLabel").append(email + "'s ClarkeCoin Address")
    $("#addy").val("");
    $("#addy").val(address);
    $("#address-modal").modal('show');
  });
});
