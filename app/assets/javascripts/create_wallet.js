$(document).ready(function(){
  $('#create-wallet').on('click', function(){
    var self = this;
    $.ajax({
      method:   'POST',
      url:      '/api/v1/wallets',
      dataType: 'JSON',
      success: function(data){
        $(self).parent().hide()
      }
    });
  })
})
