var Astek = Astek || {};

Astek.designs = Astek.designs || {
    set_master_sku_disabled: function(){
        $('#design_master_sku').prop('disabled', !$('#design_suppress_from_searches').is(':checked'));
    }
};

$(function(){
    if ($('#design_suppress_from_searches').length){
        Astek.designs.set_master_sku_disabled();
        $('#design_suppress_from_searches').click(function(){
            Astek.designs.set_master_sku_disabled();
        });
    }
});
