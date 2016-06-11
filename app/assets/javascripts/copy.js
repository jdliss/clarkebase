$(document).ready(function() {
  $('.modal-body').on("click", '#copy_btn', function() {
    var buttonClass  = $(this).attr("class");
    $('#' + buttonClass).select();
    document.execCommand('copy');
  });
});
