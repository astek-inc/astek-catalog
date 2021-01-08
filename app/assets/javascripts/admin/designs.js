var Astek = Astek || {};

Astek.designs = Astek.designs || {

    set_master_sku_disabled: function(){
        $('#design_master_sku').prop('disabled', !$('#design_suppress_from_searches').is(':checked'));
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

        $('#design_keyword_list').tagsinput({
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

    if ($('#design_suppress_from_searches').length) {
        Astek.designs.set_master_sku_disabled();
        $('#design_suppress_from_searches').click(function() {
            Astek.designs.set_master_sku_disabled();
        });
    }

    if ($('#design_keyword_list').length) {
        Astek.designs.initialize_keyword_tags();
    }

});
