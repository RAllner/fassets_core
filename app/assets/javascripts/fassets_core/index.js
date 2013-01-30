//= require_self
//= require ./assets

$.ajaxSetup({ 'beforeSend': function(xhr) {
  xhr.setRequestHeader("Accept", "text/javascript,text/html");
}});