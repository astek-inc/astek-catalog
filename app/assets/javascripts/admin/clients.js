$(function(){
    $('#generate-token-button a[data-remote]').on('ajax:success', function(e, data, status, xhr){
        $('#site_token').val(data.token);
        $(this).blur();
    });
});
