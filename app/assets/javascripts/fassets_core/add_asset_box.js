//$(document).ajaxSend(function(event, request, settings) {
//  if (typeof(AUTH_TOKEN) == "undefined") return;
//  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
//  settings.data = settings.data || "";
//  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
//});


$(document).ready(function(){
  var show_asset_box = function() {
    $.fancybox.showActivity();
    var f_width = $(window).width()*0.8;
    var f_height = $(window).height()*0.8;
    $.ajaxSetup({cache: false});
    $.get('/assets/new', { content_only: true }, function(data) {
      $.fancybox({
        content: data,
        padding: 0,
        autoDimensions: false,
        width: f_width,
        height: f_height,
        onComplete: function(){
          $("#fancybox-content").data("box-type","add_asset");
          $.fancybox.resize();
        }
      });
    });
  };
  $(window).keydown(function(event){
    switch(event.keyCode) {
    case 65: // a
      activeObj = document.activeElement;
      if (activeObj.type == "textarea") break;
      if (activeObj.type == "text") break;
      if ($(activeObj).attr("class") != undefined && $(activeObj).attr("class").indexOf("slot") != -1) break;
      if ($("#fancybox-wrap").is(":visible")) {
        $.fancybox.close();
      } else {
        show_asset_box();
      }
      break;
    }
  });
  $(document).ajaxComplete(function() {
    adjust_links();
  });
  var adjust_links = function() {
    $("#add_asset_sidebar li.asset_type").click(function(event){
      event.preventDefault();
      $.fancybox.showActivity();
      asset_type = $(event.target).data("asset-type");
      $("div.fassets_core.new").load("/assets/new", {type: asset_type, content_only: true });
      $.fancybox.resize();
      $.fancybox.hideActivity();
    });
    $("form.edit_classification input[type=submit][value=Save]").hide();
  };

  adjust_links();
  $("#new_asset_link").click(function(event){
    event.preventDefault();
    show_asset_box();
  });
  var reload_tray = function() {
    var user_id = $("#tray").data("user-id");
    $("#tray").load("/users/"+user_id+"/tray_positions/", function() {
      $('#tray .drop_button').click(function(event){
        event.preventDefault();
        var user_id = $(event.target).data("user-id");
        var tp_id = $(event.target).data("tp-id");
        $.ajax({
          type: 'DELETE',
          cache	: false,
          url		: "/users/"+user_id+"/tray_positions/"+tp_id,
          success: function(data) {
            $("#tray").load("/users/"+user_id+"/tray_positions/");
          }
        });
      });
    });
  };
});
