//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.collapsiblePanel-0.2.0
//= require fancybox
//= require jquery.purr
//= require best_in_place
//= require_self
//= require ./add_asset_box
//= require ./assets
//= require ./catalog_box
//= require ./catalogs
//= require ./classification
//= require ./edit_box
//= require ./facets
//= require ./tray

$.ajaxSetup({ 'beforeSend': function(xhr) {
  xhr.setRequestHeader("Accept", "text/javascript,text/html");
}});