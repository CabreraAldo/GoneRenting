// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){    
    $("#spinner").bind("ajaxSend", function(event) {
        //        alert(event);
        $(this).show();
        $('.black_overlay').show();
    }).bind("ajaxStop", function() {
        $(this).hide();
        $('.black_overlay').hide();
    }).bind("ajaxError", function() {
        $(this).hide();
        $('.black_overlay').hide();
    });
});