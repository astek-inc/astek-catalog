$(function(){
    setTimeout(function() {
        $('div.alert-info, div.alert-success, div.alert-warning').hide('slow')
    }, 5000);
});

// Datepicker
handle_date_picker_fields = function(){
    $('.datepicker').datepicker({
        dateFormat: 'MM d, yy',
        showOn: 'focus'
    });
};

$(function() {
    handle_date_picker_fields();
});
//

$(function(){
    $('td.actions a[data-method="delete"]').click(function(){
        return confirm('Are you sure you want to delete this record?');
    })
});

// Maintain width of row elements when dragging
var fixHelper = function(e, ui) {
    ui.children().each(function() {
        $(this).width($(this).width());
    });
    return ui;
};

$('table.sortable').ready(function(){
    // var td_count = $(this).find('tbody tr:first-child td').length;
    $('table.sortable tbody').sortable({
        cursor: 'move',
        helper: fixHelper,
        update: function(event, ui) {
            url = $(ui.item).closest('table.sortable').data('sortable-link');
            //console.log(url);

            // position_start is used with paginated data where we only see
            // a portion of the total number of rows on a given page
            position_start = $(ui.item).closest('table.sortable').data('position-start');
            if (typeof position_start === 'undefined') {
                position_start = 0;
            }
            // console.log(position_start);

            item_id = ui.item.data('item-id');
            // console.log(item_id);

            position = ui.item.index() + position_start;
            // console.log(position);

            $.ajax({
                type: 'POST',
                url: url,
                dataType: 'json',
                data: { item_id: item_id, row_order_position: position }
                //, success: function(data){ $("#progress").hide(); }
            })

        }
    });
        // {
        //     handle: '.handle',
        //     helper: fixHelper,
        //     placeholder: 'ui-sortable-placeholder',
        //     update: function(event, ui) {
        //         var tbody = this;
        //         $("#progress").show();
        //         positions = {};
        //         $.each($('tr', tbody), function(position, obj){
        //             // reg = /spree_(\w+_?)+_(\d+)/;
        //             // parts = reg.exec($(obj).prop('id'));
        //             // if (parts) {
        //             //     positions['positions['+parts[2]+']'] = position+1;
        //             // }
        //             item_id = $(obj).attr('data-item-id');
        //             console.log(item_id);
        //             positions['positions['+item_id+']'] = position+1;
        //         });
        //         $.ajax({
        //             type: 'POST',
        //             dataType: 'script',
        //             url: $(ui.item).closest("table.sortable").data("sortable-link"),
        //             data: positions,
        //             success: function(data){ $("#progress").hide(); }
        //         });
        //     },
        //     start: function (event, ui) {
        //         // Set correct height for placehoder (from dragged tr)
        //         ui.placeholder.height(ui.item.height())
        //         // Fix placeholder content to make it correct width
        //         ui.placeholder.html("<td colspan='"+(td_count-1)+"'></td><td class='actions'></td>")
        //     }
        //     // ,
        //     // stop: function (event, ui) {
        //     //     // Fix odd/even classes after reorder
        //     //     $("table.sortable tr:even").removeClass("odd even").addClass("even");
        //     //     $("table.sortable tr:odd").removeClass("odd even").addClass("odd");
        //     // }
        //
        // });
});
