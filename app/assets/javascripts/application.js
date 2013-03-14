// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery-fileupload
//= require jquery.atwho
//= require_tree .

$(function(){
  
  $(".room_join").click(function(){
    var room_id = $("#room_id").val();
    var seat_id = $(this).attr("id");
    $.ajax({
      url: "/rooms/join",
      type: "POST",
      data: "id="+room_id+"&seat_id="+seat_id
    });
  });

  $(".poker_start").click(function(){
    var room_id = $("#room_id").val();
    $.ajax({
      url: "/seats/start",
      type: "POST",
      data: "room_id="+room_id
    });
  });

  $(".poker_check").live("click", function(){
    var css = $(this).attr("class");
    css = css == "poker_img poker_check" ? "poker_img_selected poker_check" : "poker_img poker_check";
    $(this).attr("class", css);
  });

  function scan_poker(){
    var pokers = '';
    $(".poker_img_selected").each(function(){
      var poker = $(this).id;
      pokers = pokers + ","
    });
    return pokers;
  }
  
  $(".poker_play").click(function(){
    var room_id = $("#room_id").val();
    var pokers = scan_poker();
    $.ajax({
      url: "/seats/play",
      type: "POST",
      data: "room_id="+room_id+"&pokers="+pokers
    });  
  });
  

});
