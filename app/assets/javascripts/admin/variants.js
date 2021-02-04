var Astek = Astek || {};

Astek.variants = Astek.variants || {
    set_display_sale_price_disabled: function() {
        $('#variant_display_sale_price').prop('disabled', !($('#variant_sale_price').val() > 0));
        if (!($('#variant_sale_price').val() > 0)) {
            $('#variant_display_sale_price').prop('checked', false);
        }
    }
};

$(function(){

    if ($('#variant_display_sale_price').length) {
        Astek.variants.set_display_sale_price_disabled();
        $('#variant_sale_price').blur(function() {
            Astek.variants.set_display_sale_price_disabled();
        });
    }

});
