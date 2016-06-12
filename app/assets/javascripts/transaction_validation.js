$(document).ready(function() {
     $('#sendCoin').prop('disabled', true);

     $('#amount').keyup(function() {
       var input = $("#amount").val();
       if(Math.floor(input) == input && $.isNumeric(input))
           $('#sendCoin').prop('disabled', false);
     });
 });
