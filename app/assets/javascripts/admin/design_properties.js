var Astek = Astek || {};

Astek.design_properties = Astek.design_properties || {

    append_new_fieldset: function(){

        tbody = $('#design-properties');
        row = tbody.find('.design_property').last();
        new_row = row.clone();
        new_row = this.cleanup_new_row(new_row);
        tbody.append(new_row);

    },

    cleanup_new_row: function(row){

        max_index = parseInt(row.attr('data-index'));
        new_index = max_index + 1;

        row.attr('id', 'new_'+new_index)
        row.attr('data-index', new_index);

        new_row.find('input[type="text"]').each(function(){
            $(this).val('');
            $(this).attr('name', $(this).attr('name').replace('['+max_index+']', '['+new_index+']'));
            $(this).attr('id', $(this).attr('id').replace('_'+max_index+'_', '_'+new_index+'_'));
        })

        return row;

    }
};

$(function(){

    $('#new-design-property').click(function(){
        Astek.design_properties.append_new_fieldset();
        return false;
    });

    $('#design-properties').on('keydown', 'input.autocomplete', function() {
        already_auto_completed = $(this).is('ac_input');
        if (!already_auto_completed) {
            $(this).autocomplete({source: properties});
            $(this).focus();
        }
    });

});
