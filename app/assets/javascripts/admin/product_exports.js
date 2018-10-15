var Astek = Astek || {};

Astek.product_exports = Astek.product_exports || {
    collection_name_autocomplete: function(){
        $('#collection_name').autocomplete({
            source: function (request, response){
                $.ajax({
                    url: '/admin/collections/search',
                    dataType: "json",
                    data: {
                        term: request.term,
                        website_id: $('#website_id').val()
                    },
                    success: function(data) {
                        response(data);
                    }
                });
            },
            minLength: 2,
            // response: function(event, ui) {
            //     console.log(ui);
            // },
            select: function( event, ui ) {
                value = ui.item ? ui.item.id : null;
                $('#collection_id').val(value);
                $(this).attr('name', 'collection_name_'+Astek.product_exports.randhex(32));
            },
            change: function(event, ui) {
                if (ui.item === null) {
                    $('#collection_id').val('');
                    $(this).val('');
                }
            }
        });
    },
    randhex: function(len) {
        var maxlen = 8,
            min = Math.pow(16,Math.min(len,maxlen)-1)
        max = Math.pow(16,Math.min(len,maxlen)) - 1,
            n   = Math.floor( Math.random() * (max-min+1) ) + min,
            r   = n.toString(16);
        while ( r.length < len ) {
            r = r + Astek.product_exports.randhex( len - maxlen );
        }
        return r;
    }
};

$(function() {
    if ($('#collection_name').length) {
        Astek.product_exports.collection_name_autocomplete();
    }
});


