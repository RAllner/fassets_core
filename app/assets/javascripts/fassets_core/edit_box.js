$(document).ready(function(){
    // var show_edit_box = function(event) {
    //   var asset_id = $(event.target).data("asset-id");
    //   $.fancybox.showActivity();
    //   var f_width = $(window).width()*0.8;
    //   var f_height = $(window).height()*0.8;
    //   $.ajaxSetup({cache: false});
    //   $.get('/assets/'+asset_id+'/edit', { content_only: true }, function(data) {
    //     $.fancybox({
    //       content: data,
    //       padding: 0,
    //       autoDimensions: false,
    //       width: f_width,
    //       height: f_height,
    //       onComplete: function(){
    //         $("#fancybox-content").data("box-type","edit_asset");
    //         adjust_links();
    //         $.fancybox.resize();
    //       }
    //     });
    //   });
    // };

    // $("body .edit_button").live("click",function(event){
      
    //   // event.preventDefault();
    //   // show_edit_box(event);
    // });
    var adjust_links = function(){
      $("#fancybox-content li.asset_type").click(function(event){
        event.preventDefault();
        $.fancybox.showActivity();
        var type = event.target.href.split("=")[1];
        $("#fancybox-content").load("/add_asset_box?type="+type);
        $.fancybox.resize();
        $.fancybox.hideActivity();
      });
      $("form.edit_classification input[type=submit][value=Save]").hide();
    };
  $(document).ajaxStop(function() {
    if($("#fancybox-content").data("box-type") == "edit_asset"){
      adjust_links();
    }
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
