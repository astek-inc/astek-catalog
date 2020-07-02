var Astek = Astek || {};

Astek.order_limits_exports = Astek.order_limits_exports || {
    collection_name_autocomplete: function(){
        $('#collection_name').autocomplete({
            source: function (request, response){
                $.ajax({
                    url: '/admin/collections/csv_export_search',
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
