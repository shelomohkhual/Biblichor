// NOTIFICATION AND ALERT
window.setTimeout(function() {
    $(".alert").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove(); 
    });
}, 4000);

$(document).ready(function() { $(".genre-tags").select2({
    allowClear: true,
                                                tags: true,
                                                tokenSeparators: [','],
                                                theme: 'bootstrap',
                                                placeholder: 'add-genre-tags'
                                                }); });
