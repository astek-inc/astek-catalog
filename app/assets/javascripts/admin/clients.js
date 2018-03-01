$(function(){
    $('#generate-token-button a[data-remote]').on('ajax:success', function(e, data, status, xhr){
        $('#client_token').val(data.token);
        $(this).blur();
    });
});
