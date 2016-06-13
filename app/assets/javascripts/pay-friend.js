$(document).ready(function() {
  $('body').on('click', '.toggle-pay-modal', function() {
    event.preventDefault();
    var email = $(".toggle-address-modal").attr("data-email");
    var address = $(".toggle-address-modal").attr("data-address");

    $("#pay-to-header").empty();
    $("#pay-to-header").append("Pay " + email)
    $("#hidden-key").val("");
    $("#hidden-key").val(address);
    $("#pay-modal").modal('show');
  });
});
