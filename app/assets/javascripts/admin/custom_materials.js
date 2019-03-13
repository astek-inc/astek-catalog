var Astek = Astek || {};

Astek.custom_materials = Astek.custom_materials || {};

Astek.custom_materials.init = function() {

    self = this;

    $(function() {
        self.update_default_material_options();

        $('#design_user_can_select_material').change(function() {
            if (this.checked) {
                $('#material-checkboxes input[type="checkbox"]').prop('disabled', false);
                $('#default_material_id').prop('disabled', false);
                $('#material-checkboxes input[type="checkbox"].default-group').prop('checked', true);
            } else {
                $('#material-checkboxes input[type="checkbox"]').prop('checked', false).prop('disabled', true);
                $('#default_material_id').prop('disabled', true);
            }
            self.update_default_material_options();
        });

        $('#material-checkboxes input[type="checkbox"]').change(function(){
            self.update_default_material_options();
        });

    });
};

Astek.custom_materials.update_default_material_options = function() {

    var material_ids = [];
    $.each($('#material-checkboxes input[type="checkbox"]:checked'), function(){
        material_ids.push($(this).val());
    });

    // Remove current options from selector
    var select = $('#default_material_id');
    $('option', select).remove();

    var options = [];
    options.push('<option value="">Select</option>');

    // Add material options corresponding to the checkboxes clicked
    if (material_ids.length) {
        var substrate_count = substrates.length;
        for (var i = 0; i < substrate_count; i++) {
            if (material_ids.includes(substrates[i]['id'].toString())) {
                // console.log(substrates[i]['id'] + '::' + default_custom_material_id);
                options.push('<option value="'+substrates[i]['id']+'"'+(substrates[i]['id'] == default_custom_material_id ? ' selected' : '')+'>'+substrates[i]['name']+'</option>');
            }
        }
    }

    // Append the new options to the selector
    $.each(options, function(index, option){
        select.append(option);
    });

}
