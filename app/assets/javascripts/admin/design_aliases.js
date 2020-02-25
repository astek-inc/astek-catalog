var Astek = Astek || {};

Astek.design_aliases = Astek.design_aliases || {}

Astek.design_aliases.design_name_autocomplete = function(){
  $('#design_name').autocomplete({
    source: function (request, response){
      $.ajax({
        url: '/admin/designs/design_alias_search',
        dataType: 'json',
        data: {
          term: request.term
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
      $('#design_alias_design_id').val(value);
      $(this).attr('name', 'design_name_'+Astek.design_aliases.randhex(32));
    },
    change: function(event, ui) {
      if (ui.item === null) {
        $('#design_alias_design_id').val('');
        $(this).val('');
      }
      $(this).attr('name', 'design_name_'+Astek.design_aliases.randhex(32));
    }
  }).click(function(){
    $(this).attr('name', 'design_name_'+Astek.design_aliases.randhex(32));
  }).blur(function(){
    $(this).attr('name', 'design_name_'+Astek.design_aliases.randhex(32));
  });
};

Astek.design_aliases.randhex = function(len) {
  var maxlen = 8,
    min = Math.pow(16,Math.min(len,maxlen)-1)
  max = Math.pow(16,Math.min(len,maxlen)) - 1,
    n   = Math.floor( Math.random() * (max-min+1) ) + min,
    r   = n.toString(16);
  while ( r.length < len ) {
    r = r + Astek.design_aliases.randhex( len - maxlen );
  }
  return r;
};
