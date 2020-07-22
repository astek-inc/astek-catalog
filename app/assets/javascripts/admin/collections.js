var Astek = Astek || {};

Astek.collections = Astek.collections || {
    set_lead_time_required: function () {
        // Digital and Theme product categories are printed to order and do not require a lead time
        if ([1, 4].includes(parseInt($('#collection_product_category_id').val()))) {
            $('#collection_lead_time_id').attr('required', false);
            $('#collection_lead_time_id').attr('disabled', true);
            $('#lead-time-group span').hide();
        } else {
            $('#collection_lead_time_id').attr('required', true);
            $('#collection_lead_time_id').attr('disabled', false);
            $('#lead-time-group span').show();
        }
    },

    initialize_keyword_tags: function(){

        var keyword_tags = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            prefetch: {
                url: '/admin/keywords/list',
                filter: function(list) {
                    return $.map(list, function(kw) {
                        return { name: kw.name };
                    });
                }
            }
        });
        keyword_tags.initialize();

        $('#collection_keyword_list').tagsinput({
            typeaheadjs: {
                name: 'keyword_tags',
                displayKey: 'name',
                valueKey: 'name',
                source: keyword_tags.ttAdapter()
            }
        });

    }

};

$(function(){
    Astek.collections.set_lead_time_required();
    $('#collection_product_category_id').change(function(){
        Astek.collections.set_lead_time_required();
    });

    if ($('#collection_keyword_list').length) {
        Astek.collections.initialize_keyword_tags();
    }
});


