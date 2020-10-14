var Astek = Astek || {};

Astek.clipboard = {
    showMessage: function(div_class_name, text) {
        $('#flash-container').html('<div id="clipboard-message" class="' + div_class_name + '">' + text + '</div>');
        $('#clipboard-message').show(200, function(){
            setTimeout(function() {
                $('#clipboard-message').hide('slow')
            }, 5000)
        });
    },
    showSuccessMessage: function() {
        this.showMessage('alert alert-success', 'Data copied successfully.');
    },
    showErrorMessage: function() {
        this.showMessage('alert alert-warning', 'An error occurred while copying the data. Please try again.');
    },
    updateClipboard: function(text) {
        var self = this;
        navigator.clipboard.writeText(text).then(function() {
            self.showSuccessMessage();
        }, function() {
            self.showErrorMessage();
        });
    },
    init: function() {
        var self = this;
        $('#copy-to-clipboard').click(function(){
            text = $('.to-copy').val();
            self.updateClipboard(text);
            $(this).blur();
        });
    }
};

$(function(){
    if ($('#copy-to-clipboard').length) {
        Astek.clipboard.init();
    }
});
