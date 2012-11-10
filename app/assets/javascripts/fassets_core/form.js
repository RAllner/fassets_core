$(document).ready(function(){
  $(document).bind('ajax:success', function(evt, xhr, status){
    reload_tray();
    $.fancybox.close();
  });
  $(document).bind('ajax:error', function(evt, xhr, status, error){
    var responseObject = $.parseJSON(xhr.responseText),
        errors = new Object();

    $('form').find('.errors').empty();
    $.each(responseObject.errors, function(key, val){
      var field = key;
      errors[field] = $('<ul />');
      $.each(val, function(){
        errors[field].append('<li>' + this + '</li>');
      });
    });

    $.each(errors, function(key, val){
      $('form').find('#'+ key.replace('.','_') +'.errors').html(val);
    });
  });
});
