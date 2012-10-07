// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require tinymce-jquery
//= require bootstrap
//= require_tree .
$('#accept_link').live('click', function(event){
    event.preventDefault();
    $.get($(this).attr('data-href') + "?standby_flight=" + $('#standby_flight').val(), function(data){} );
});

$('#pax_link').live('click', function(event){
    event.preventDefault();
    $.get($(this).attr('data-href'), function(data){} );
});
jQuery(function($) {
    $('#accept_link').bind("ajax:before", function(event, data, status, xhr) {
        var inp = $('#standby_flight');
        if (inp.val().length < 1)
            alert("Please enter the accepted flight number");
    });
});

jQuery(function($) {
    $('#accept_selected').live('click', function(event, data, status, xhr) {
        var inp = $('#standby_flight');
        if (inp.val().length < 1)
            alert("Please enter the accepted flight number");
    });
});

$(document).ready(function() {
    $(document).on('keyup keydown', "#briefingpost_content", function() {
        var charLength = $(this).val().length;
//        alert(charLength);
        $('#char-count').text(charLength);
    });
});