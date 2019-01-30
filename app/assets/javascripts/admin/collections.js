var Astek = Astek || {};

Astek.collections = Astek.collections || {
    set_lead_time_required: function () {
        if ($('#collection_product_category_id').val() == 1) {
            $('#collection_lead_time_id').attr('required', false);
            $('#collection_lead_time_id').attr('disabled', true);
            $('#lead-time-group span').hide();
        } else {
            $('#collection_lead_time_id').attr('required', true);
            $('#collection_lead_time_id').attr('disabled', false);
            $('#lead-time-group span').show();
        }
    }
};

$(function(){
    Astek.collections.set_lead_time_required();
    $('#collection_product_category_id').change(function(){
        Astek.collections.set_lead_time_required();
    });
});


