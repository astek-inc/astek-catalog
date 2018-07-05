var Astek = Astek || {};

Astek.product_exports = Astek.product_exports || {
    collection_name_autocomplete: function(){
        $('#collection_name').autocomplete({
            source: '/admin/collections/search',
            minLength: 2,
            // response: function(event, ui) {
            //     console.log(ui);
            // },
            select: function( event, ui ) {
                value = ui.item ? ui.item.id : null;
                $('#collection_id').val(value);
            },
            change: function(event, ui) {
                if (ui.item === null) {
                    $('#collection_id').val('');
                    $(this).val('');
                }
            }
        });
    }
};

$(function() {
    Astek.product_exports.collection_name_autocomplete();
});
