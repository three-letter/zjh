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
  var user_id = $("#current_user_id").val();
  var room_id = $("#room_id").val();
  if(user_id > 0){
    var faye = new Faye.Client('http://pfaye.herokuapp.com/faye');

    faye.subscribe("/user/" + user_id, function(data){
      eval(data);
    });
    
    faye.subscribe("/poker/" + room_id, function(data){
      eval(data);
    });
  }

  $(".poker_start").click(function(){
    $.ajax({
      url: "/comments/ready",
      type: "post",
      data: "cast_id="+room_id
    });
  });

  $(".poker_out").click(function(){
    $.ajax({
      url: "/comments/out",
      type: "post",
      data: "cast_id="+room_id
    });
  });

  function send_poker(){
    $.ajax({
      url: "/casts/send_poker",
      type: "POST",
      data: "cast_id="+room_id
    });
  }

  $(".btn_score").click(function (){
    var sort = $("#play_sort").val();
    var score = $("#play_score").val();
    var s = $(this).attr("id");
    if( s < score )
      alert("跟牌不能少于"+score+"金币");
    else
      $.ajax({
        url: "/comments/play",
        type: "POST",
        data: "cast_id="+room_id+"&score="+s+"&sort="+sort
      });
  });

  $(".poker_open").click(function(){
    var score = $("#play_score");
    var all_score = $("#score").text();
    $.ajax({
      url: "/casts/open",
      type: "POST",
      data: "cast_id="+room_id+"&score="+score+"&all_score="+all_score
    });
  });

  function scan_user(){
    var discuss_users = {} ;
    var names = [] ;
    $(".cast_discuss_user").each(function(){
      var u_name = $(this).text();
      discuss_users[u_name] = u_name;
    });
    var index = 0;
    for(key in discuss_users){
      names[index] = key;
      index += 1;
    }
    return names;
  }

  $("#comment_content").atwho("@", {
    data: scan_user()
  })

});
