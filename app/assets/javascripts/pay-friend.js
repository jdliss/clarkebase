$(document).ready(function() {
  $('.toggle-pay-modal').on('click', function() {
    event.preventDefault();
    var email = $(this).attr("data-email");
    var address = $(this).attr("data-address");

    $("#pay-to-header").empty();
    $("#pay-to-header").append("Pay " + email)
    $("#hidden-key").val("");
    $("#hidden-key").val(address);
    $("#pay-modal").modal('show');
  });
});
