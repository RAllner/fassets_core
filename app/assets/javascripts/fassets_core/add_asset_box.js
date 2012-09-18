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
    $("#add_asset_content").css("left",$("#catalog_list").width()+10);
    $("#add_asset_content").css("width",$("#fancybox-content").width()-$("#catalog_list").width()-30-$("#facets").width());
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
          adjust_links();
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
    var adjust_links = function(){
      $("#fancybox-content li.asset_type").click(function(event){
        event.preventDefault();
        $.fancybox.showActivity();
        asset_type = $(event.target).data("asset-type");
        $("#fancybox-content").load("/assets/new", {type: asset_type, content_only: true }, function() {
          adjust_links();
        });
        $.fancybox.resize();
        $.fancybox.hideActivity();
      });
      $("#fancybox-content .asset_create_button").click(function(event){
        event.preventDefault();
        $.fancybox.showActivity();
        var action = $("#add_asset_content form").attr("action");
        $.post(action, $("#add_asset_content form").serialize(), function(data){
          $("#fancybox-content #add_asset_content").load(data[0].edit_box_url+"?type="+data[0].content_type);
        });
        reload_tray();
        $.fancybox.resize();;
        $.fancybox.hideActivity();
      });
      $("#fancybox-content .asset_submit_button").click(function(event){
        event.preventDefault();
        $.fancybox.showActivity();
        //var token = encodeURIComponent(AUTH_TOKEN)
        var asset_type = $(event.target).data("asset-type");
        reload_tray();
        $.fancybox.hideActivity();
      });
      $("form.edit_classification input[type=submit][value=Save]").hide();
    };

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
